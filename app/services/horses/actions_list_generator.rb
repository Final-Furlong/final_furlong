module Horses
  class ActionsListGenerator
    include Rails.application.routes.url_helpers

    attr_reader :horse

    def call(horse:)
      @horse = horse
      actions.select do |action_hash|
        policy_class = action_hash[:policy] || CurrentStable::HorsePolicy
        if action_hash[:object]
          begin
            subject = horse.send(action_hash[:object])
            subject ||= horse.send("build_#{action_hash[:object]}")
            policy_class.new(Current.user, subject).send("#{action_hash[:key]}?")
          rescue
            false
          end
        else
          policy_class.new(Current.user, horse).send("#{action_hash[:key]}?")
        end
      end.map do |action|
        action[:object] ? [action[:key], action[:object]].join("_") : action[:key]
      end
    end

    private

    def actions
      [
        { key: :rename },
        { key: :geld },
        { key: :change_status },
        { key: :change_owner, policy: Admin::HorsePolicy },
        { key: :create_lease_offer, policy: CurrentStable::LeaseOfferPolicy },
        { key: :accept, policy: CurrentStable::LeaseOfferPolicy, object: :lease_offer },
        { key: :reject, policy: CurrentStable::LeaseOfferPolicy, object: :lease_offer },
        { key: :cancel, policy: CurrentStable::LeaseOfferPolicy, object: :lease_offer },
        { key: :terminate, policy: CurrentStable::LeasePolicy, object: :current_lease },
        { key: :create, policy: CurrentStable::SaleOfferPolicy, object: :sale_offer },
        { key: :accept, policy: CurrentStable::SaleOfferPolicy, object: :sale_offer },
        { key: :destroy, policy: CurrentStable::SaleOfferPolicy, object: :sale_offer },
        { key: :cancel, policy: CurrentStable::SaleOfferPolicy, object: :sale_offer },
        { key: :consign_to_auction },
        { key: :remove_from_auction },
        { key: :breed, policy: CurrentStable::BroodmarePolicy },
        { key: :update_racing_options, policy: CurrentStable::RacehorsePolicy },
        { key: :nominate, policy: CurrentStable::RacehorsePolicy },
        { key: :enter_race, policy: CurrentStable::RacehorsePolicy },
        { key: :scratch_race, policy: CurrentStable::RacehorsePolicy },
        { key: :run_workout, policy: CurrentStable::RacehorsePolicy },
        { key: :run_jump_trial, policy: CurrentStable::RacehorsePolicy },
        { key: :board, policy: CurrentStable::RacehorsePolicy },
        { key: :stop_boarding, policy: CurrentStable::RacehorsePolicy },
        { key: :update_stud_options, policy: CurrentStable::StallionPolicy },
        { key: :manage_bookings, policy: CurrentStable::StallionPolicy },
        { key: :nominate, policy: CurrentStable::StallionPolicy },
        { key: :view_comments },
        { key: :nominate_weanling }
      ]
    end
  end
end

