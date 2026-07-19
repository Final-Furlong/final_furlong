module Horses::Broodmare
  class Death
    attr_reader :horse, :date

    def initialize(horse:, date:)
      @horse = horse
      @date = date
    end

    def run
      stillborn = false
      premature = false
      death = horse.future_events.where(event_type: "die").first
      ActiveRecord::Base.transaction do
        horse.auction_horse&.destroy
        horse.lease_offer&.destroy
        horse.sale_offer&.destroy
        cancel_lease if horse.manager != horse.owner
        if horse.state != "deceased"
          horse.update(state: "deceased", date_of_death: date, manager: horse.owner, leaser: nil)
          notify_death(horse:, stable: horse.owner) if horse.changed?
        end
        Horses::Horse::Foal.where(dam: horse, state: "unborn").find_each do |foal|
          if (foal.date_of_birth - death.date).to_i > Config::Horses.max_premature_days
            foal.update(state: "deceased", date_of_birth: date, date_of_death: date)
            notify_stillborn(foal:, mare: horse)
            stillborn = true
          else
            foal.update(state: "active", date_of_birth: date)
            appearance = foal.appearance
            appearance.update(birth_height: appearance.birth_height - rand(1..2))
            notify_premature(foal:, mare: horse)
            premature = true
          end
        end
      end
      { stillborn:, premature: }
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
end

