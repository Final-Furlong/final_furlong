namespace :db do
  desc "Show database size, table row counts, and index usage"
  task health: :environment do
    conn = ActiveRecord::Base.connection

    # Database size
    db_size = conn.execute(<<~SQL).first
      SELECT pg_size_pretty(pg_database_size(current_database())) AS size
    SQL
    puts "Database size: #{db_size['size']}"
    puts ""

    # Table sizes and row counts
    tables = conn.execute(<<~SQL)
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
    unused = conn.execute(<<~SQL)
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
    long_queries = conn.execute(<<~SQL)
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
        puts "  PID: #{q['pid']} | Duration: #{q['duration']} | State: #{q['state']}"
        puts "  #{q['query'][0..120]}"
        puts ""
      end
    else
      puts "No long-running queries."
    end
  end
end
