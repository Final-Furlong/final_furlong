module Horses
  class ActionsListGenerator
    include Rails.application.routes.url_helpers

    attr_reader :horse

    def call(horse:)
      @horse = horse
      actions.select do |action|
        CurrentStable::HorsePolicy.new(Current.user, horse).send("#{action}?")
      end.map { |action| { action:, url: action_url(action), requires_form: !idempotent?(action), method: form_method(action) } }
    end

    private

    def form_method(action)
      case action.to_s.downcase
      when "accept_lease_offer"
        :post
      when "cancel_lease_offer"
        :delete
      end
    end

    def idempotent?(action)
      case action.to_s.downcase
      when "accept_lease_offer", "cancel_lease_offer"
        false
      else
        true
      end
    end

    def action_url(action)
      case action.to_s.downcase
      when "accept_lease_offer"
        lease_offer_acceptance_path(horse)
      when "create_lease_offer"
        new_lease_offer_path(horse)
      when "cancel_lease_offer"
        lease_offer_path(horse)
      when "terminate_lease"
        new_lease_termination_path(horse)
      else
        "#"
      end
    end

    def actions
      %w[
        rename
        geld
        change_status
        change_owner
        set_for_sale
        unset_for_sale
        create_lease_offer
        accept_lease_offer
        reject_lease_offer
        cancel_lease_offer
        terminate_lease
        consign_to_auction
        remove_from_auction
        update_racing_options
        update_stud_options
        breed_mare
        manage_bookings
        view_comments
        view_sales
        view_highlights
        view_shipping
        nominate_racehorse
        nominate_stud
        nominate_weanling
        enter_race
        scratch_race
        run_workout
        run_jump_trial
        board_horse
        stop_boarding
      ]
    end
  end
end

