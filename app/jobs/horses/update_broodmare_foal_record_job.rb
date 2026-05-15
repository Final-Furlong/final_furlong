class Horses::UpdateBroodmareFoalRecordJob < ApplicationJob
  queue_as :latency_2m

  def perform(horse)
    Horses::BroodmareFoalRecordCreator.new.create_record(horse:)
  end
end

