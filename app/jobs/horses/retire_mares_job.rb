class Horses::RetireMaresJob < ApplicationJob
  queue_as :default

  def perform
    return if run_today?

    retired = 0
    Horses::Horse.where(status: "broodmare").joins(:future_events).merge(Horses::FutureEvent.past.retirement).find_each do |mare|
      next if Horses::FutureEvent.past.death.exists?(horse: mare)

      ActiveRecord::Base.transaction do
        mare.update(status: "retired_broodmare")
        Horses::Breeding.where(mare:).where.not(status: "bred").delete_all
        Horses::Breeding.where(mare:, status: "bred").where("date > ?", Date.current).find_each do |future_breeding|
          future_breeding.first_foal&.destroy!
          future_breeding.second_foal&.destroy!
          future_breeding.destroy!
        end
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

