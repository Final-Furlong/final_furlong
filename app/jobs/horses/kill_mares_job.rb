class Horses::KillMaresJob < ApplicationJob
  queue_as :latency_2m

  def perform
    return if run_today?

    died = 0
    stillborn = 0
    premature = 0
    Horses::Horse::Broodmare.active.joins(:future_events).merge(Horses::FutureEvent.past.death).find_each do |mare|
      death = mare.future_events.where(event_type: "die").first
      ActiveRecord::Base.transaction do
        mare.update(state: "deceased", date_of_death: death.date)
        notify_death(horse: mare)
        Horses::Horse::Foal.where(dam: mare, state: "unborn").find_each do |foal|
          if (foal.date_of_birth - death.date).to_i > Config::Horses.max_premature_days
            foal.update(state: "deceased", date_of_birth: death.date, date_of_death: death.date)
            notify_stillborn(foal:, mare:)
            stillborn += 1
          else
            foal.update(state: "active", date_of_birth: death.date)
            appearance = foal.appearance
            appearance.update(birth_height: appearance.birth_height - rand(1..2))
            notify_premature(foal:, mare:)
            premature += 1
          end
        end
        died += 1
      end
    end
    store_job_info(outcome: { died:, stillborn:, premature: })
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

