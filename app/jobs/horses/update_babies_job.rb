class Horses::UpdateBabiesJob < ApplicationJob
  queue_as :default

  def perform
    return if run_today?

    born = 0
    stillborn = 0
    Horses::Horse.where(status: "unborn").where(date_of_birth: ..Date.current).find_each do |horse|
      ActiveRecord::Base.transaction do
        if horse.date_of_birth == horse.date_of_death
          horse.update(status: "deceased")
          Legacy::Horse.where(ID: horse.legacy_id).update(Status: 2, DOD: horse.date_of_death - 4.years)
          notify_stillborn(foal:)
          stillborn += 1
        else
          horse.update(status: "weanling")
          Legacy::Horse.where(ID: horse.legacy_id).update(Status: 9)
          born += 1
        end
        if horse.dam
          horse.dam.due_dates.where(status: "bred").where(date: ...horse.date_of_birth).delete_all
          Legacy::Breeding.where(Mare: horse.dam.legacy_id).where.not(Due: nil).delete_all
        end
      end
    end
    store_job_info(outcome: { born:, stillborn: })
  end

  private

  def notify_stillborn(foal:)
    sire = foal.sire.name
    dam = foal.dam.name
    Game::NotificationCreator.new.create_notification(
      type: ::HorseStillbornNotification,
      user: foal.owner.user,
      params: { horse_id: foal.slug, sire_name: sire, dam_name: dam }
    )
  end

  def notify_birth(foal:)
    if foal.created?
      created = true
    else
      created = false
      sire = foal.sire.name
      dam = foal.dam.name
    end
    Game::NotificationCreator.new.create_notification(
      type: ::HorseBornNotification,
      user: foal.owner.user,
      params: { horse_id: foal.slug, created:, sire_name: sire, dam_name: dam }
    )
  end
end

