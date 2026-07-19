module Horses::Broodmare
  class Retirement
    attr_reader :horse

    def initialize(horse:)
      @horse = horse
    end

    def run
      return if Horses::FutureEvent.past.death.exists?(horse:)

      ActiveRecord::Base.transaction do
        horse.auction_horse&.destroy
        horse.lease_offer&.destroy
        horse.sale_offer&.destroy
        Horses::Breeding.where(mare: horse).where.not(status: "bred").delete_all
        Horses::Breeding.where(mare: horse, status: "bred").where("date > ?", Date.current).find_each do |future_breeding|
          future_breeding.first_foal&.destroy!
          future_breeding.second_foal&.destroy!
          future_breeding.destroy!
        end
        cancel_lease if horse.manager != horse.owner
        horse.update(state: "retired", manager: horse.owner, leaser: nil)
        notify_retirement(horse:, stable: horse.owner) if horse.changed?
        ::Horses::Event.create!(horse:, event_type: "retired_breeding", date: Date.current)
      end
    end

    private

    def cancel_lease(horse:)
      lease = horse.current_lease
      lease.update(active: false, early_termination_date: Date.current)
      notify_retirement(horse:, stable: lease.leaser)
    end

    def notify_retirement(horse:, stable:)
      Game::NotificationCreator.new.create_notification(
        type: ::Notifications::Horse::RetiredNotification,
        user: stable.user,
        params: { horse_id: horse.slug, horse_name: horse.name }
      )
    end
  end
end

