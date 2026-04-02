class Horses::UpdateHorseAttributesJob < ApplicationJob
  queue_as :default

  def perform(horse)
    ::Racing::RaceRecord.refresh
    ::Racing::LifetimeRaceRecord.refresh
    ::Horses::UpdateHorseAttributesService.new.call(horse:)
  end
end

