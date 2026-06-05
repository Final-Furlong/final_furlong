class Daily::DeleteReadNotificationsJob < ApplicationJob
  queue_as :latency_30s

  def perform
    return if run_today?

    count = Notification.where(read_at: ...(Date.current - Config::Game.notification_expiration_after_reading.days)).delete_all
    store_job_info(outcome: { count: })
  end
end

