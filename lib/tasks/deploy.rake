namespace :deploy do
  desc "Verify deployment health beyond basic health check"
  task verify: :environment do
    checks = []

    # Database connectivity and basic query
    begin
      ActiveRecord::Base.connection.execute("SELECT 1").first
      checks << { name: "Database", status: "OK" }
    rescue => e
      checks << { name: "Database", status: "FAIL", error: e.message }
    end

    # Redis connectivity (if using Sidekiq or caching)
    if defined?(Redis)
      begin
        Redis.new(url: ENV["REDIS_URL"]).ping
        checks << { name: "Redis", status: "OK" }
      rescue => e
        checks << { name: "Redis", status: "FAIL", error: e.message }
      end
    end

    # GoodJob health (if applicable)
    if defined?(GoodJob)
      begin
        pending = GoodJob::Job.where(finished_at: nil).count
        checks << { name: "GoodJob pending jobs", status: "OK", count: pending }
      rescue => e
        checks << { name: "GoodJob", status: "FAIL", error: e.message }
      end
    end

    # Active Storage (if applicable)
    if defined?(ActiveStorage)
      begin
        ActiveStorage::Blob.count
        checks << { name: "Active Storage", status: "OK" }
      rescue => e
        checks << { name: "Active Storage", status: "FAIL", error: e.message }
      end
    end

    # Application version and boot time
    checks << { name: "Rails version", status: Rails.version }
    checks << { name: "Ruby version", status: RUBY_VERSION }
    checks << { name: "Environment", status: Rails.env }

    checks.each do |check|
      line = "#{check[:name]}: #{check[:status]}"
      line += " (#{check[:count]})" if check[:count]
      line += " - #{check[:error]}" if check[:error]
      puts line
    end

    failures = checks.select { |c| c[:status] == "FAIL" }
    exit(1) if failures.any?
  end
end

