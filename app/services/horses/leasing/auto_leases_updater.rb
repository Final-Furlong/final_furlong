module Horses::Leasing
  class AutoLeasesUpdater
    def call
      expired_leases = 0
      Horses::Lease.expired.includes(:horse, leaser: :user, owner: :user).find_each do |lease|
        horse = lease.horse
        ActiveRecord::Base.transaction do
          Game::NotificationCreator.new.create_notification(
            type: ::Notifications::HorseLease::ExpiryNotification,
            user: lease.owner.user,
            params: {
              horse_id: horse.slug,
              horse_name: horse.name
            }
          )
          Game::NotificationCreator.new.create_notification(
            type: ::Notifications::HorseLease::ExpiryNotification,
            user: lease.leaser.user,
            params: {
              horse_id: horse.slug,
              horse_name: horse.name
            }
          )
          horse.update(manager: horse.owner)
          horse.training_schedules_horse&.destroy
          lease.destroy!
        end
        expired_leases += 1
      end
      { expired_leases: }
    end
  end
end

