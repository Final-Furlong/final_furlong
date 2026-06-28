module Horses
  class StatusUpdater
    attr_reader :horse, :status

    def update_status(horse:, status:)
      @horse = horse
      result = Result.new(updated: false)

      ActiveRecord::Base.transaction do
        if horse.racehorse?
          horse.retire(status:)
        elsif horse.stud?
          horse.update(state: "retired")
          horse.stud_options&.destroy
          ::Horses::Event.create!(horse:, event_type: "retired_breeding", date: Date.current)
        elsif horse.broodmare?
          horse.update(state: "retired")
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

