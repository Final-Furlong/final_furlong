class Horses::UpdateStudFoalRecordJob < ApplicationJob
  queue_as :default

  def perform(horse)
    Horses::StudFoalRecordCreator.new.create_record(horse:)
  end
end

