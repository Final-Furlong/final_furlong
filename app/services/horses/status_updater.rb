module Horses
  class StatusUpdater
    attr_reader :horse, :status
    def update_status(horse:, status:)
      @horse = horse
      @status = Horses::Status::ACTIVE_BREEDING_STATUSES.include?(horse.status) ? "retired_#{horse.status}" : status_params[:status]
      result = Result.new(updated: false)

      ActiveRecord::Base.transaction do
        if horse.racehorse?
          Horses::BoardingUpdater.new.stop_boarding(boarding: horse.current_boarding) if horse.current_boarding
          horse.race_entries.delete_all
          horse.future_race_entries.delete_all
          Racing::Claim.where(horse:).delete_all
          # TODO: delete nominations
          horse.current_injuries.delete_all
          horse.training_schedule_horses&.destroy
        elsif horse.stud?
          horse.stud_options&.destroy
        end
        @horse.update(status: new_status)
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

