class Horses::UpdateBabiesJob < ApplicationJob
  queue_as :latency_2m

  def perform
    return if run_today?

    born = 0
    stillborn = 0
    Horses::Horse.where(status: "unborn").where(date_of_birth: ..Date.current).find_each do |foal|
      ActiveRecord::Base.transaction do
        if foal.date_of_birth == foal.date_of_death
          foal.update(status: "deceased", state: "deceased")
          notify_stillborn(foal:)
          stillborn += 1
        else
          foal.update(status: "weanling", state: "active")
          notify_birth(foal:)
          born += 1
        end
        if foal.dam
          foal.dam.due_dates.where(status: "bred").where(year: (Date.current.month == 12) ? Date.current.year : Date.current.year - 1).delete_all
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
      type: ::Notifications::Horse::StillbornNotification,
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
      type: ::Notifications::Horse::BornNotification,
      user: foal.owner.user,
      params: { horse_id: foal.slug, created:, sire_name: sire, dam_name: dam }
    )
  end
end

