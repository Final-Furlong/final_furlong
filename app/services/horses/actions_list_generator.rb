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
        { key: :ship },
        { key: :update_race_options, policy: CurrentStable::RacehorsePolicy },
        { key: :view_training_schedule, policy: CurrentStable::RacehorsePolicy },
        { key: :set_training_schedule, policy: CurrentStable::RacehorsePolicy },
        { key: :board, policy: CurrentStable::RacehorsePolicy },
        { key: :stop_boarding, policy: CurrentStable::RacehorsePolicy },
        { key: :run_workout, policy: CurrentStable::RacehorsePolicy },
        { key: :run_jump_trial, policy: CurrentStable::RacehorsePolicy },
        { key: :nominate, policy: CurrentStable::RacehorsePolicy },
        { key: :create_lease_offer, policy: CurrentStable::LeaseOfferPolicy },
        { key: :accept, policy: CurrentStable::LeaseOfferPolicy, object: :lease_offer },
        { key: :reject, policy: CurrentStable::LeaseOfferPolicy, object: :lease_offer },
        { key: :cancel, policy: CurrentStable::LeaseOfferPolicy, object: :lease_offer },
        { key: :terminate, policy: CurrentStable::LeasePolicy, object: :current_lease },
        { key: :create, policy: CurrentStable::SaleOfferPolicy, object: :sale_offer },
        { key: :accept, policy: CurrentStable::SaleOfferPolicy, object: :sale_offer },
        { key: :reject, policy: CurrentStable::SaleOfferPolicy, object: :sale_offer },
        { key: :destroy, policy: CurrentStable::SaleOfferPolicy, object: :sale_offer },
        { key: :consign_to_auction },
        { key: :remove_from_auction },
        { key: :update_stud_options, policy: CurrentStable::StallionPolicy },
        { key: :nominate_weanling },
        { key: :change_owner, policy: Admin::HorsePolicy }
      ]
    end
  end
end

