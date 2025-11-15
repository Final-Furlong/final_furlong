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
            policy_class.new(Current.user, subject).send("#{action_hash[:key]}?")
          rescue
            false
          end
        else
          policy_class.new(Current.user, horse).send("#{action_hash[:key]}?")
        end
      end.map do |action|
        hash = {
          action:, url: action_url(action[:key], action[:object]),
          requires_form: !idempotent?(action[:key], action[:object])
        }
        if hash[:requires_form]
          hash[:method] = form_method(action[:key], action[:object])
          hash[:confirm] = form_confirm(action[:key], action[:object])
        end
        hash
      end
    end

    private

    def form_confirm(key, object)
      case object.to_s.downcase
      when "lease_offer"
        case key.to_s.downcase
        when "accept"
          I18n.t("notifications.lease_offer_notification.accept_lease.confirm")
        end
      end
    end

    def form_method(key, object)
      case object.to_s.downcase
      when "lease_offer"
        case key.to_s.downcase
        when "accept"
          :post
        when "cancel"
          :delete
        end
      end
    end

    def idempotent?(key, object)
      case object.to_s.downcase
      when "lease_offer"
        case key.to_s.downcase
        when "accept", "cancel"
          false
        else
          true
        end
      else
        true
      end
    end

    def action_url(key, object)
      case object.to_s.downcase
      when "current_lease"
        new_lease_termination_path(horse)
      when "lease_offer"
        case key.to_s.downcase
        when "accept"
          lease_offer_acceptance_path(horse)
        when "cancel"
          lease_offer_path(horse)
        else
          "#"
        end
      else
        case key.to_s.downcase
        when "create_lease_offer"
          new_lease_offer_path(horse)
        else
          "#"
        end
      end
    end

    def actions
      [
        { key: :rename },
        { key: :geld },
        { key: :change_status },
        { key: :change_owner, policy: Admin::HorsePolicy },
        { key: :set_for_sale },
        { key: :unset_for_sale },
        { key: :create_lease_offer, policy: CurrentStable::LeaseOfferPolicy },
        { key: :accept, policy: CurrentStable::LeaseOfferPolicy, object: :lease_offer },
        { key: :reject, policy: CurrentStable::LeaseOfferPolicy, object: :lease_offer },
        { key: :cancel, policy: CurrentStable::LeaseOfferPolicy, object: :lease_offer },
        { key: :terminate, policy: CurrentStable::LeasePolicy, object: :current_lease },
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
        { key: :view_sales },
        { key: :view_highlights },
        { key: :view_shipping },
        { key: :nominate_weanling }
      ]
    end
  end
end

