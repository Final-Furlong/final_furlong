module Horses::Stud
  class Retirement
    attr_reader :horse

    def initialize(horse:)
      @horse = horse
    end

    def run
      ActiveRecord::Base.transaction do
        cancel_lease if horse.manager != horse.owner
        horse.lease_offer&.destroy
        horse.sale_offer&.destroy
        Horses::Stud::FutureBreedingEraser.new(horse:, type: "retired").run
        horse.update(state: "retired", manager: horse.owner, leaser: nil)
        notify_retirement(horse:)
        ::Horses::Event.create!(horse:, event_type: "retired_breeding", date: Date.current)
      end
    end

    private

    def cancel_lease(horse:)
      lease = horse.current_lease
      lease.update(active: false, early_termination_date: Date.current)
      notify_retirement(lease.leaser)
    end

    def notify_retirement(horse:)
      Game::NotificationCreator.new.create_notification(
        type: ::Notifications::Horse::RetiredNotification,
        user: horse.owner.user,
        params: { horse_id: horse.slug, horse_name: horse.name }
      )
    end
  end
end

