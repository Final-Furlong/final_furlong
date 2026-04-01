class CustomizedHealthController < Rails::HealthController
  def upstream
    status = UpstreamStatus.new
    status.primary_db = check_primary_db
    status.legacy_db = check_legacy_db
    status.canary = check_canary

    render_upstream(status:, ok: status.is_ok)
  end

  def check_canary
    return UpstreamStatus::STATUS_OK unless Rails.env.production?

    last_run = Rails.cache.fetch("canary_last_run")
    if last_run && last_run >= 10.minutes.ago
      UpstreamStatus::STATUS_OK
    else
      "Canary is gone!"
    end
  end

  def check_primary_db
    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    if defined?(ActiveRecord::Base)
      ActiveRecord::Base.connection.verify!
    end
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
    UpstreamStatus::STATUS_OK
  rescue => e
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started
    begin
      Rails.logger.warn("[/up] DB check failed: #{e.class}: #{e.message}")
    rescue
      nil
    end
    { ok: false, error: e.class.name, message: e.message, duration_s: duration.round(4) }
  end

  def check_legacy_db
    Legacy::Record.connected_to(role: :writing) do
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      if defined?(Legacy::Record)
        Legacy::Record.connection.verify!
      end
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
      UpstreamStatus::STATUS_OK
    rescue => e
      duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started
      begin
        Rails.logger.warn("[/up] DB check failed: #{e.class}: #{e.message}")
      rescue
        nil
      end
      { ok: false, error: e.class.name, message: e.message, duration_s: duration.round(4) }
    end
  end

  private

  def render_upstream(status:, ok:)
    http_status = 200
    unless ok
      http_status = 503
    end

    render json: status, status: http_status
  end
end

