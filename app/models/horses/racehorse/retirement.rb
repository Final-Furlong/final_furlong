module Horses::Racehorse
  class Retirement
    attr_reader :horse, :status

    def initialize(horse:, status:)
      @horse = horse
      @status = status
    end

    def run
      BoardingUpdater.new.stop_boarding(boarding: horse.current_boarding) if horse.current_boarding
      ActiveRecord::Base.transaction do
        horse.race_entries.delete_all
        horse.future_race_entries.delete_all
        ::Racing::Claim.joins(:entry).where(entry: { horse: }).delete_all
        # TODO: delete nominations
        horse.current_injuries.delete_all
        horse.training_schedules_horse&.destroy
        horse.breeders_cup_nomination&.destroy
        case status
        when "broodmare"
          horse.update(type: "Horses::Horse::Broodmare")
        when "stud"
          horse.update(type: "Horses::Horse::Stud")
        when "retired"
          horse.update(state: "retired")
        end
        ::Horses::Event.create!(horse:, event_type: "retired_racing", date: Date.current)
      end
    end
  end
end

