module Horses::Stud
  class Death
    attr_reader :horse

    def initialize(horse:)
      @horse = horse
    end

    def run
      ActiveRecord::Base.transaction do
        horse.lease_offer&.destroy
        horse.sale_offer&.destroy
        cancel_lease if horse.manager != horse.owner
        Horses::Stud::FutureBreedingEraser.new(horse:, type: "died").run
        if horse.state != "deceased"
          horse.update(state: "deceased", manager: horse.owner, leaser: nil)
          notify_death(horse:)
        end
      end
    end

    private

    def cancel_lease(horse:)
      lease = horse.current_lease
      lease.update(active: false, early_termination_date: Date.current)
      notify_death(lease.leaser)
    end

    def notify_death(horse:)
      Game::NotificationCreator.new.create_notification(
        type: ::Notifications::Horse::RetiredNotification,
        user: horse.owner.user,
        params: { horse_id: horse.slug, horse_name: horse.name }
      )
    end
  end
end

