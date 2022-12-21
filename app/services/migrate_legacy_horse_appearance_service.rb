class MigrateLegacyHorseAppearanceService
  attr_reader :legacy_horse, :locations

  def initialize(horse:)
    @legacy_horse = horse
  end

  def call
    return unless Horse.exists?(legacy_id: legacy_horse.id)

    color = LegacyHorseColor.find(legacy_horse.color)
    horse.update!(colour: HorseColour.new(color))
  rescue StandardError => e
    Rails.logger.error "Info: #{legacy_horse.inspect}"
    raise e
  end
end

