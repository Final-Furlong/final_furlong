class UpdateLegacyHorseJockeysJob < ApplicationJob
  queue_as :low_priority

  def perform
    Legacy::HorseJockey.find_each do |legacy_hj|
      horse = Horses::Horse.find_by(legacy_id: legacy_hj.Horse)
      legacy_hj.destroy and next unless horse
      legacy_hj.destroy and next unless horse.racehorse?

      migrate_horse_jockey(legacy_hj, horse)
    end
  end

  private

  def migrate_horse_jockey(legacy_record, horse)
    jockey = Racing::Jockey.find_by(legacy_id: legacy_record.Jockey)
    return unless jockey

    relation = horse.jockey_relationships.find_or_initialize_by(jockey:)
    relation.experience = legacy_record.XP
    relation.experience = relation.experience.clamp(0, 100)
    relation.happiness = legacy_record.Happy
    relation.happiness = 100 if relation.happiness > 100
    relation.save!
  end
end

