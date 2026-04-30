class Horses::UpdateStudFoalRecordJob < ApplicationJob
  queue_as :latency_2m

  def perform(horse)
    Horses::StudFoalRecordCreator.new.create_record(horse:)
  end
end

