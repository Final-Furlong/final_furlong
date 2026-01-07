class UpdateLegacyHorsesJob < ApplicationJob
  queue_as :low_priority

  def perform
    if Racing::Racetrack.count < 21
      MigrateLegacyRacetrackService.new.call
    end
    Legacy::Horse.where(rails_id: nil).find_each do |legacy_horse|
      migrate_legacy_horse(legacy_horse:)
    end
    Legacy::Horse.where("last_modified > last_synced_to_rails_at")
      .or(Legacy::Horse.where(last_synced_to_rails_at: nil)).find_each do |legacy_horse|
      migrate_legacy_horse(legacy_horse:)
    end
    remaining_count = Legacy::Horse.where(rails_id: nil).count
    remaining_count += Legacy::Horse.where("last_modified > last_synced_to_rails_at").count
    UpdateLegacyHorsesJob.set(wait: 5.seconds).perform_later if remaining_count.positive?
  end

  private

  def migrate_legacy_horse(legacy_horse:)
    result = MigrateLegacyHorseService.new(horse: legacy_horse).call
    if result
      result = MigrateLegacyHorseAppearanceService.new(legacy_horse:).call
      if result
        horse_id = Horses::Horse.where(legacy_id: legacy_horse.ID).pick(:id)
        Legacy::Horse.find(legacy_horse.ID).update(rails_id: horse_id, last_synced_to_rails_at: Time.current)
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    message = "ID: #{legacy_horse.id}, #{e.message}"
    raise e, message:
  end
end

