class CanaryJob < ApplicationJob
  queue_as :latency_30s

  def perform
    # Record successful execution
    Rails.cache.write(
      "canary_last_run",
      Time.current,
      expires_in: 10.minutes
    )

    # Send metric
    ActiveSupport::Notifications.instrument(
      "canary.success",
      timestamp: Time.current
    )
  end
end

