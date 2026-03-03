class UpdateLegacyHorsesJob < ApplicationJob
  queue_as :low_priority

  def perform
    if Racing::Racetrack.count < 21
      MigrateLegacyRacetrackService.new.call
    end
    new_horses = 0
    existing_horses = 0
    Legacy::Horse.where(rails_id: nil).find_each do |legacy_horse|
      migrate_legacy_horse(legacy_horse:)
      new_horses += 1
    end
    Legacy::Horse.where.not(Status: 3).where("last_modified > last_synced_to_rails_at").find_each do |legacy_horse|
      migrate_legacy_horse(legacy_horse:)
      existing_horses += 1
    end
    Legacy::Horse.where(last_synced_to_rails_at: nil).find_each do |legacy_horse|
      migrate_legacy_horse(legacy_horse:)
      new_horses += 1
    end
    remaining_count = Legacy::Horse.where(rails_id: nil).count
    remaining_count += Legacy::Horse.where.not(Status: 3).where("last_modified > last_synced_to_rails_at").count
    if remaining_count.positive?
      UpdateLegacyHorsesJob.set(wait: 5.seconds).perform_later if remaining_count.positive?
    else
      UpdateLegacyRacingStatsJob.perform_later
    end
    store_job_info(outcome: { new_horses:, existing_horses: })
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

