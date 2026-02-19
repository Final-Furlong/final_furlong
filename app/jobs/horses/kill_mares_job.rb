class Horses::KillMaresJob < ApplicationJob
  queue_as :default

  def perform
    died = 0
    stillborn = 0
    premature = 0
    Horses::Horse.where(status: "broodmare").joins(:future_events).merge(Horses::FutureEvent.past.death).find_each do |mare|
      death = mare.future_events.where(event_type: "die").first
      ActiveRecord::Base.transaction do
        mare.update(status: "deceased", date_of_death: death.date)
        notify_death(horse: mare)
        Legacy::Horse.where(ID: mare.legacy_id).update(Status: 2, DOD: death.date + 4.years)
        Horses::Horse.where(dam: mare, status: "unborn").find_each do |foal|
          if (foal.date_of_birth - death.date).to_i > Config::Horses.max_premature_days
            foal.update(status: "deceased", date_of_birth: death.date, date_of_death: death.date)
            Legacy::Horse.where(ID: foal.legacy_id).update(Status: 2, DOB: death.date + 4.years, DOD: death.date + 4.years)
            notify_stillborn(foal:, mare:)
            stillborn += 1
          else
            foal.update(status: "weanling", date_of_birth: death.date)
            appearance = foal.appearance
            appearance.update(birth_height: appearance.birth_height - rand(1..2))
            Legacy::Horse.where(ID: foal.legacy_id).update(Status: 9, DOB: death.date + 4.years, CurrentHeight: appearance.birth_height)
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
      type: ::HorseDiedNotification,
      user: horse.owner.user,
      params: { horse_id: horse.slug, horse_name: horse.name }
    )
  end

  def notify_stillborn(foal:, mare:)
    sire = foal.sire.name
    Game::NotificationCreator.new.create_notification(
      type: ::HorseStillbornNotification,
      user: foal.owner.user,
      params: { horse_id: foal.slug, sire_name: sire, dam_name: mare.name }
    )
  end

  def notify_premature(foal:, mare:)
    sire = foal.sire.name
    Game::NotificationCreator.new.create_notification(
      type: ::HorsePrematureNotification,
      user: foal.owner.user,
      params: { horse_id: foal.slug, sire_name: sire, dam_name: mare.name }
    )
  end
end

