module Horses
  class BreedingProcessor < ApplicationService
    attr_reader :breeding, :mare, :stud

    def do_breeding(breeding:, mare:, stud:, day: nil, auto: false)
      @breeding = breeding
      @mare = mare
      @stud = stud
      breeding.stud = stud
      if day.present?
        @breeding.date = Date.new(@breeding.date.year, @breeding.date.month, day.to_i)
      end

      if breeding.date < Date.current && !auto
        result.error = error("date_in_past")
        return result
      end

      result = Result.new(breeding:)
      if breeding.status == "bred"
        result.error = error("mare_already_bred")
        return result
      elsif breeding.status == "denied"
        result.error = error("mare_not_eligible")
        return result
      end

      if breeding.mare_id != mare.id && !breeding.open_booking?
        result.error = error("mare_not_eligible")
        return result
      elsif breeding.open_booking?
        breeding.mare = mare
        breeding.open_booking = false
      end

      if breeding.stable != mare.manager
        result.error = error("mare_not_eligible")
        return result
      end

      if mare.current_location != breeding.stud.manager
        if auto
          starting_location = mare.current_location.racetrack.location
          ending_location = breeding.stud.manager.racetrack.location
          route = if starting_location == ending_location
            Shipping::Route.new(miles: mare.current_location.miles_from_track, road_days: 1, road_cost: 25)
          else
            Shipping::Route.find_by(starting_location:, ending_location:)
          end
          if route.road_days
            departure_date = Date.current - route.road_days.days
            mode = "road"
          else
            departure_date = Date.current - route.air_days.days
            mode = "air"
          end
          Horses::Broodmare::Shipment.create(
            horse: mare,
            arrival_date: Date.current,
            departure_date:,
            mode:,
            scheduled: false,
            ending_farm: breeding.stud.manager,
            starting_farm: mare.current_location
          )
        else
          result.error = error("mare_needs_shipping")
          return result
        end
      end

      if mare.in_transit?
        result.error = error("mare_in_transit")
        return result
      end

      if breeding.fee >= mare.manager.available_balance.to_i
        result.error = error("cannot_afford_fee")
        return result
      end

      ActiveRecord::Base.transaction do
        description = "Breeding: #{mare.name} to #{stud.name}"
        Accounts::BudgetTransactionCreator.new.create_transaction(stable: mare.manager, description:, amount: breeding.fee.abs * -1, activity_type: "breeding")
        update_activity(mare.manager.user, :bred_mare)

        description = "Stud Booking: #{stud.name} & #{mare.name}"
        Accounts::BudgetTransactionCreator.new.create_transaction(stable: stud.manager, description:, amount: breeding.fee.abs, activity_type: "breeding")
        update_activity(stud.manager.user, :bred_stud)
        breeding.event = breeding.pick_event
        breeding.status = "bred"
        breeding.due_date = breeding.pick_due_date
        if breeding.save!
          stud.stud_options.update(outside_mares_count: stud.stud_options.outside_mares_count + 1) if stud.manager != mare.manager
          result.updated = true
          result.breeding = breeding
        else
          result.updated = false
          result.breeding = breeding
          result.error = breeding.errors.full_messages.to_sentence
        end
      end
      result
    end

    class Result
      attr_accessor :updated, :breeding, :error

      def initialize(breeding:, updated: false)
        @updated = updated
        @breeding = breeding
        @error = nil
      end

      def updated?
        @updated
      end
    end

    private

    def update_activity(user, type)
      activity = user.activity || user.build_activity
      activities = activity.activities
      activities[type] = Time.current
      activity.update(activities:)
    end

    def error(key)
      I18n.t("services.breedings.processor.#{key}")
    end
  end
end

