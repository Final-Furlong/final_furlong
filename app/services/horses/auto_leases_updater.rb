module Horses
  class AutoLeasesUpdater
    def call
      expired_leases = 0
      Horses::Lease.expired.includes(:horse, leaser: :user, owner: :user).find_each do |lease|
        horse = lease.horse
        ActiveRecord::Base.transaction do
          Game::NotificationCreator.new.create_notification(
            type: ::LeaseExpiryNotification,
            user: lease.owner.user,
            params: {
              horse_id: horse.slug,
              horse_name: horse.name
            }
          )
          Game::NotificationCreator.new.create_notification(
            type: ::LeaseExpiryNotification,
            user: lease.leaser.user,
            params: {
              horse_id: horse.slug,
              horse_name: horse.name
            }
          )
          legacy_horse = Legacy::Horse.find_by(ID: horse.legacy_id)
          legacy_horse&.update(Leased: 0, Leaser: 0)
          Legacy::ViewRacehorses.find_by(horse_id: horse.legacy_id)&.update(leased: 0, leaser: 0)
          Legacy::ViewTrainingSchedules.find_by(horse_id: horse.legacy_id)&.update(leased: 0, leaser: 0)
          lease.destroy!
        end
        expired_leases += 1
      end
      { expired_leases: }
    end
  end
end

