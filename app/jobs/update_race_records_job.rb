class UpdateRaceRecordsJob < ApplicationJob
  queue_as :low_priority

  def perform
    MigrateRaceRecordsService.new.call
  end
end

