namespace :ops do
  desc "Clear all Rails caches (fragment, action, page)"
  task clear_cache: :environment do
    Rails.cache.clear
    puts "Rails cache cleared at #{Time.current}"
  end

  desc "Show environment configuration (redacted secrets)"
  task env_check: :environment do
    critical_vars = %w[
      RAILS_ENV
      DATABASE_URL
      RAILS_LOG_TO_STDOUT
      RAILS_SERVE_STATIC_FILES
      RAILS_MAX_THREADS
      WEB_CONCURRENCY
    ]

    critical_vars.each do |var|
      value = ENV[var]
      if value.nil?
        puts "  #{var}: NOT SET"
      elsif var.match?(/PASSWORD|SECRET|KEY|TOKEN|URL/)
        puts "  #{var}: #{value[0..4]}*****"
      else
        puts "  #{var}: #{value}"
      end
    end
  end

  desc "Show pending migrations"
  task pending_migrations: :environment do
    pending = ActiveRecord::Base.connection.migration_context.open.pending_migrations
    if pending.any?
      puts "Pending migrations:"
      pending.each { |m| puts "  #{m.version} - #{m.name}" }
    else
      puts "No pending migrations."
    end
  end

  desc "Warm application caches after deployment"
  task warm_cache: :environment do
    puts "Warming critical caches..."

    # Add your application-specific cache warming here
    # Examples:
    # - Preload frequently accessed configuration
    # - Cache expensive database queries
    # - Warm up connection pools

    if defined?(Rails.application.config.cache_store)
      puts "  Cache store: #{Rails.application.config.cache_store}"
    end

    puts "Cache warming complete at #{Time.current}"
  end

  desc "Kill stuck GoodJob jobs older than specified hours"
  task kill_stuck_jobs: :environment do
    if defined?(GoodJob)
      stuck = GoodJob::Process.inactive
      count = stuck.count
      GoodJob::Process.cleanup if count.to_i.positive?
      puts "Released #{count} stuck jobs"
    else
      puts "GoodJob not available"
    end
  end
end

