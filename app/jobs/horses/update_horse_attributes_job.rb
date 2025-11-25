class Horses::UpdateHorseAttributesJob < ApplicationJob
  queue_as :default

  def perform(horse)
    ::Racing::LifetimeRaceRecord.refresh
    ::Horses::UpdateHorseAttributesService.new.call(horse:)
  end
end

