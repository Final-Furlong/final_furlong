module Horses
  class BoardingCreator < ApplicationService
    attr_reader :horse, :location

    def start_boarding(horse:, legacy_racetrack:)
      location = Location.joins(:racetrack).find_by(racetracks: { name: legacy_racetrack.Name })

      result = Result.new(created: false, horse: horse)
      unless location
        result.error = error("location_not_found")
        return result
      end

      result.location = location
      unless location.has_farm?
        result.error = error("invalid_location")
        return result
      end

      unless horse.racehorse?
        result.error = error("horse_not_racehorse")
        return result
      end

      if horse.current_boarding
        result.error = error("horse_currently_boarded")
        return result
      end

      total_days_in_location = 0
      horse.boardings.current_year.where(location:).find_each do |boarding|
        start_date = [Date.new(Date.current.year, 1, 1), boarding.start_date].max
        end_date = boarding.end_date || Date.current

        total_days_in_location += end_date - start_date
      end
      if total_days_in_location >= 30
        result.error = error("max_days_reached")
        return result
      end

      boarding = Horses::Boarding.new(horse:, location:, start_date: Date.current)
      if boarding.save!
        result.created = true
        result.boarding = boarding
      else
        result.created = false
        result.boarding = boarding
        result.error = boarding.errors.full_messages.to_sentence
      end
      result
    end

    class Result
      attr_reader :horse
      attr_accessor :created, :location, :boarding, :error

      def initialize(created:, horse:)
        @created = created
        @horse = horse
        @error = nil
      end

      def created?
        @created
      end
    end

    private

    def error(key)
      I18n.t("services.boarding.creator.#{key}")
    end
  end
end

