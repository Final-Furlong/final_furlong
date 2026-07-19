class Horses::FutureEventsJob < ApplicationJob
  queue_as :latency_2m

  def perform
    return if run_today?

    retired = 0
    died = 0
    stillborn = 0
    premature = 0
    Horses::Horse.joins(:future_events).merge(Horses::FutureEvent.past).find_each do |horse|
      event = horse.future_events.past.order(date: :asc).first
      ActiveRecord::Base.transaction do
        if event.event_type == "retire"
          horse.retire
          retired += 1
        elsif event.event_type == "die"
          result = horse.die
          if horse.broodmare?
            stillborn += 1 if result[:stillborn]
            premature += 1 if result[:premature]
          end
          died += 1
        end
        event.destroy
      end
    end
    store_job_info(outcome: { retired:, died:, stillborn:, premature: })
  end

  private

  def notify_death(horse:)
    Game::NotificationCreator.new.create_notification(
      type: ::Notifications::Horse::DiedNotification,
      user: horse.owner.user,
      params: { horse_id: horse.slug, horse_name: horse.name }
    )
  end

  def notify_stillborn(foal:, mare:)
    sire = foal.sire.name
    Game::NotificationCreator.new.create_notification(
      type: ::Notifications::Horse::StillbornNotification,
      user: foal.owner.user,
      params: { horse_id: foal.slug, sire_name: sire, dam_name: mare.name }
    )
  end

  def notify_premature(foal:, mare:)
    sire = foal.sire.name
    Game::NotificationCreator.new.create_notification(
      type: ::Notifications::Horse::PrematureNotification,
      user: foal.owner.user,
      params: { horse_id: foal.slug, sire_name: sire, dam_name: mare.name }
    )
  end
end

