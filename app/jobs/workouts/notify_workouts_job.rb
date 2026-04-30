class Workouts::NotifyWorkoutsJob < ApplicationJob
  queue_as :latency_30s

  def perform(batch, context)
    User::SendDeveloperNotifications.call(title: "FF Workouts Finished", message: "#{batch.properties[:queued]} horses worked!")
  end
end
