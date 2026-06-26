module Horses
  class StatusUpdater
    attr_reader :horse, :status

    def update_status(horse:, status:)
      @horse = horse
      pd status
      @status = Horses::Status::ACTIVE_BREEDING_STATUSES.include?(horse.status) ? "retired_#{horse.status}" : status
      result = Result.new(updated: false)

      ActiveRecord::Base.transaction do
        if horse.racehorse?
          horse.retire(status:)
        elsif horse.stud?
          horse.stud_options&.destroy
          ::Horses::Event.create!(horse:, event_type: "retired_breeding", date: Date.current)
        elsif horse.broodmare?
          ::Horses::Event.create!(horse:, event_type: "retired_breeding", date: Date.current)
        end
        @horse.update(status:)
      end
      result.updated = @horse.valid?
      result
    end

    class Result
      attr_accessor :error, :updated

      def initialize(updated: false, error: nil)
        @updated = updated
        @error = nil
      end

      def updated?
        @updated
      end
    end
  end
end

