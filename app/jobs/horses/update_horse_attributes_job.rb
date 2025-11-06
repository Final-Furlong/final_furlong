class Horses::UpdateHorseAttributesJob < ApplicationJob
  queue_as :default

  def perform(horse)
    Horses::UpdateHorseAttributesService.new.call(horse:)
  end
end

