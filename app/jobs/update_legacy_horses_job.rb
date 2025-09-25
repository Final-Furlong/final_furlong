class UpdateLegacyHorsesJob < ApplicationJob
  queue_as :low_priority

  def perform
    Legacy::Horse.where(rails_id: nil).limit(20).find_each do |legacy_horse|
      result = MigrateLegacyHorseService.new(horse: legacy_horse).call
      if result
        result = MigrateLegacyHorseAppearanceService.new(legacy_horse:).call
        if result
          horse_id = Horses::Horse.where(legacy_id: legacy_horse.ID).pick(:id)
          Legacy::Horse.find(legacy_horse.ID).update(rails_id: horse_id)
        end
      end
    end
  end
end

