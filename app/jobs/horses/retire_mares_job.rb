class Horses::RetireMaresJob < ApplicationJob
  queue_as :default

  def perform
    return if run_today?

    retired = 0
    Horses::Horse.where(status: "broodmare").joins(:future_events).merge(Horses::FutureEvent.past.retirement).find_each do |mare|
      ActiveRecord::Base.transaction do
        mare.update(status: "retired_broodmare")
        Legacy::Horse.where(ID: mare.legacy_id).update(Status: 5)
        notify_retirement(horse: mare)
      end
      retired += 1
    end
    store_job_info(outcome: { retired: })
  end

  private

  def notify_retirement(horse:)
    Game::NotificationCreator.new.create_notification(
      type: ::HorseRetiredNotification,
      user: horse.owner.user,
      params: { horse_id: horse.slug, horse_name: horse.name }
    )
  end
end

