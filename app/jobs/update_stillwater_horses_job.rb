class UpdateStillwaterHorsesJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :low_priority

  def perform
    step :process do |step|
      owner = Account::Stable.find_by(name: "Stillwater Farms")
      flat_jocks = Racing::Jockey.flat.active.all.to_a
      jump_jocks = Racing::Jockey.jump.active.all.to_a
      Horses::Horse.racehorse.where(owner:).find_each do |horse|
        options = horse.race_options
        relationships = horse.jockey_relationships.order(happiness: :desc, experience: :desc).all.to_a
        relationships = relationships.delete_if { |jr| jr.happiness < jr.experience / 2 }
        all_jocks = (options.racehorse_type == "flat") ? flat_jocks : jump_jocks

        if options.first_jockey_id.nil?
          options.first_jockey = (relationships.size > 0) ? relationships[0].jockey : all_jocks.sample
        end
        if options.second_jockey_id.nil?
          options.second_jockey = (relationships.size > 1) ? relationships[1].jockey : all_jocks.sample
        end
        if options.third_jockey_id.nil?
          options.third_jockey = (relationships.size > 2) ? relationships[2].jockey : all_jocks.sample
        end
        while options.first_jockey == options.second_jockey
          options.second_jockey = all_jocks.sample
        end
        while options.first_jockey == options.third_jockey ||
            options.second_jockey == options.third_jockey
          options.third_jockey = all_jocks.sample
        end
        options.save!
        horse.race_entries.each do |entry|
          entry.update(first_jockey: options.first_jockey, second_jockey: options.second_jockey, third_jockey: options.third_jockey)
        end
        horse.future_race_entries.each do |entry|
          entry.update(first_jockey: options.first_jockey, second_jockey: options.second_jockey, third_jockey: options.third_jockey)
        end
      end
    end
  end

  private

  def migrate_horse_jockey(legacy_record, horse)
    jockey = Racing::Jockey.find_by(legacy_id: legacy_record.Jockey)
    return unless jockey

    relation = Racing::HorseJockeyRelationship.find_or_initialize_by(horse:, jockey:)
    relation.experience ||= 0
    relation.happiness ||= 0
    relation.experience = legacy_record.XP if legacy_record.XP > relation.experience.to_i
    relation.experience = relation.experience.clamp(0, 100)
    relation.happiness = legacy_record.Happy if legacy_record.Happy > relation.happiness.to_i
    relation.happiness = 100 if relation.happiness > 100
    relation.save!
  end
end

