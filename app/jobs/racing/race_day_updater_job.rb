class Racing::RaceDayUpdaterJob < ApplicationJob
  queue_as :default

  def perform(date:)
    Racing::RaceRecordUpdater.new.update_records(date:)
  end
end

