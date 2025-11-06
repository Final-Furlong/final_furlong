class Horses::UpdateBroodmareFoalRecordJob < ApplicationJob
  queue_as :default

  def perform(horse)
    Horses::BroodmareFoalRecordCreator.new.create_record(horse:)
  end
end

