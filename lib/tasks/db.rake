require "colorize"
require "fileutils"

namespace :db do
  desc "Show database size, table row counts, and index usage"
  task health: :environment do
    conn = ActiveRecord::Base.connection

    # Database size
    db_size = conn.execute(<<~SQL.squish).first
      SELECT pg_size_pretty(pg_database_size(current_database())) AS size
    SQL
    puts "Database size: #{db_size["size"]}"
    puts ""

    # Table sizes and row counts
    tables = conn.execute(<<~SQL.squish)
      SELECT
        schemaname || '.' || relname AS table,
        pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
        n_live_tup AS row_estimate
      FROM pg_stat_user_tables
      ORDER BY pg_total_relation_size(relid) DESC
      LIMIT 20
    SQL

    puts "Top 20 tables by size:"
    puts "-" * 60
    tables.each do |t|
      puts "  %-35s %10s  ~%d rows" % [t["table"], t["total_size"], t["row_estimate"]]
    end
    puts ""

    # Unused indexes (candidates for removal)
    unused = conn.execute(<<~SQL.squish)
      SELECT
        schemaname || '.' || relname AS table,
        indexrelname AS index,
        pg_size_pretty(pg_relation_size(i.indexrelid)) AS size,
        idx_scan AS scans
      FROM pg_stat_user_indexes ui
      JOIN pg_index i ON ui.indexrelid = i.indexrelid
      WHERE idx_scan < 50
        AND NOT indisunique
        AND NOT indisprimary
        AND pg_relation_size(i.indexrelid) > 1024 * 1024
      ORDER BY pg_relation_size(i.indexrelid) DESC
      LIMIT 10
    SQL

    if unused.any?
      puts "Potentially unused indexes (< 50 scans, > 1MB):"
      puts "-" * 60
      unused.each do |idx|
        puts "  %-30s %-35s %8s  %d scans" % [idx["table"], idx["index"], idx["size"], idx["scans"]]
      end
    end
    puts ""

    # Long-running queries
    long_queries = conn.execute(<<~SQL.squish)
      SELECT
        pid,
        now() - pg_stat_activity.query_start AS duration,
        query,
        state
      FROM pg_stat_activity
      WHERE (now() - pg_stat_activity.query_start) > interval '30 seconds'
        AND state != 'idle'
        AND query NOT LIKE '%pg_stat_activity%'
      ORDER BY duration DESC
      LIMIT 5
    SQL

    if long_queries.any?
      puts "Long-running queries (> 30s):"
      puts "-" * 60
      long_queries.each do |q|
        puts "  PID: #{q["pid"]} | Duration: #{q["duration"]} | State: #{q["state"]}"
        puts "  #{q["query"][0..120]}"
        puts ""
      end
    else
      puts "No long-running queries."
    end
  end

  desc "Download prod db snapshot and apply to staging environment"
  task :prod_to_staging, [:force] => [:environment] do |t, args|
    if !Rails.env.staging?
      log "This task can only be run in staging environment!", color: :red
    else
      force = args[:force] == "yes"
      log "Force argument: #{force}"
      today = Date.current.strftime("%y%m%d")
      backup_name = Rails.application.credentials.backup_db.file_name!
      backup_name = backup_name.dup
      backup_name.sub!("today", today)
      backup_location = Rails.application.credentials.backup_db.file_location!
      backup_location = backup_location.dup
      gzip_name = "#{backup_name}.gz"
      gzip_location = "#{backup_location}#{gzip_name}"
      temp_file_location = Rails.root.join("tmp/#{gzip_name}")
      exists = system "ls -la #{temp_file_location}"
      if exists && !force
        log "Today's backup has been downloaded"
      else
        log "Copying today's backup"
        exists = system "ls -la #{gzip_location}"
        if !exists
          log "Backup file does not exist", color: :red
          return
        end
        system! "cp #{gzip_location} #{temp_file_location}"
      end
      log "Unzipping backup file"
      system! "gunzip -k -f #{temp_file_location}"
      temp_file_location = Rails.root.join("tmp/#{backup_name}")
      log "Putting site in maintenance mode"
      system! "RAILS_ENV=staging bundle exec rake maintenance:start"
      system! "systemctl --user stop final_furlong_puma_staging.service"
      log "Deleting staging database"
      system! "RAILS_ENV=staging DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:drop"
      log "Re-creating staging database"
      system! "RAILS_ENV=staging rails db:create"
      log "Importing prod database"
      staging_db_name = Rails.application.credentials.db_name!
      staging_db_user = Rails.application.credentials.db_user
      system! "psql -U #{staging_db_user} -h localhost #{staging_db_name} < #{temp_file_location}"
      log "Update ActiveRecord environment to staging"
      ActiveRecord::Base.connection.execute "UPDATE ar_internal_metadata SET value = 'staging' WHERE key = 'environment'"
      log "Exiting maintenance mode for site"
      system! "RAILS_ENV=staging bundle exec rake maintenance:end"
      system! "systemctl --user stop final_furlong_puma_staging.service"
      log "Cleaning up files"
      system! "rm #{temp_file_location}"
      temp_file_location = Rails.root.join("tmp/#{gzip_name}")
      system! "rm #{temp_file_location}"
      log "All done!", color: :green
    end
  end

  desc "Clear out staging db to save space"
  task :prune_staging, [:force] => [:environment] do |t, args|
    if !Rails.env.staging?
      log "This task can only be run in staging environment!", color: :red
    else
      force = args[:force] == "yes"
      log "Force argument: #{force}"
      log "Putting site in maintenance mode"
      system! "RAILS_ENV=staging bundle exec rake maintenance:start"
      system! "systemctl --user stop final_furlong_puma_staging.service"
      log "Deleting staging database"
      system! "RAILS_ENV=staging DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rails db:drop"
      log "Re-creating staging database"
      system! "RAILS_ENV=staging rails db:create"
      system! "RAILS_ENV=staging rails db:migrate"
      log "Exiting maintenance mode for site"
      system! "RAILS_ENV=staging bundle exec rake maintenance:end"
      system! "systemctl --user stop final_furlong_puma_staging.service"
      log "All done!", color: :green
    end
  end
end

private

def system!(*args)
  log "Executing #{args}"
  if system(*args)
    log "#{args} succeeded", color: :green
  else
    log "#{args} failed", color: :red
    abort
  end
end

def log(message, color: :yellow)
  if color == false
    puts "[ rake/db ] #{message}".uncolorize
  else
    puts "[ rake/db ] #{message}".colorize(color)
  end
end

