module Horses::Racehorse
  class Death
    attr_reader :horse, :date

    def initialize(horse:, date:)
      @horse = horse
      @date = date
    end

    def run
      BoardingUpdater.new.stop_boarding(boarding: horse.current_boarding) if horse.current_boarding
      ActiveRecord::Base.transaction do
        horse.auction_horse&.destroy
        horse.lease_offer&.destroy
        horse.sale_offer&.destroy
        horse.race_entries.delete_all
        horse.future_race_entries.delete_all
        ::Racing::Claim.joins(:entry).where(entry: { horse: }).delete_all
        horse.breeders_cup_nomination&.destroy
        horse.current_injuries.delete_all
        horse.training_schedules_horse&.destroy
        horse.breeders_cup_nomination&.destroy
        cancel_lease(horse:) if horse.current_lease
        if horse.state != "deceased"
          horse.update(state: "deceased", date_of_death: date)
          notify_death(horse:, stable: horse.owner)
        end
      end
    end

    private

    def cancel_lease(horse:)
      lease = horse.current_lease
      lease.update(active: false, early_termination_date: Date.current)
      notify_death(horse:, stable: lease.leaser)
    end

    def notify_death(horse:, stable:)
      Game::NotificationCreator.new.create_notification(
        type: ::Notifications::Horse::DiedNotification,
        user: stable.user,
        params: { horse_id: horse.slug, horse_name: horse.name }
      )
    end
  end
end

