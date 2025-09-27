class UpdateLegacyHorsesJob < ApplicationJob
  queue_as :low_priority

  def perform
    Legacy::Horse.where(rails_id: nil).limit(50).find_each do |legacy_horse|
      result = MigrateLegacyHorseService.new(horse: legacy_horse).call
      if result
        result = MigrateLegacyHorseAppearanceService.new(legacy_horse:).call
        if result
          horse_id = Horses::Horse.where(legacy_id: legacy_horse.ID).pick(:id)
          Legacy::Horse.find(legacy_horse.ID).update(rails_id: horse_id)
        end
      end
    end
    Horses::Horse.where.not(name: living_famous_studs).where.not(status: "deceased")
      .order(updated_at: :asc).limit(50).find_each do |horse|
      legacy_horse = Legacy::Horse.find(horse.legacy_id)
      result = MigrateLegacyHorseService.new(horse: legacy_horse).call
      raise StandardError, "Could not migrate horse with legacy id: #{horse.legacy_id}" unless result
    end
  end

  private

  def living_famous_studs
    [
      "Candy Ride",
      "Ghostzapper",
      "Dubawi",
      "Invasor",
      "Curlin",
      "Blame",
      "Dunaden",
      "Sea the Stars",
      "Animal Kingdom",
      "Frankel",
      "Mucho Macho Man",
      "California Chrome",
      "American Pharoah",
      "Frosted",
      "Golden Horn",
      "Gun Runner",
      "Nyquist",
      "Talismanic",
      "City of Light",
      "Thunder Snow",
      "Justify",
      "Knicks Go",
      "Authentic",
      "Cody's Wish",
      "Flightline",
      "War Front"
    ]
  end
end

