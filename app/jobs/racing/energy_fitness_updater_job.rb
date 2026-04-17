class Racing::EnergyFitnessUpdaterJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :default

  def perform
    return if run_today?

    horses = 0

    step :initialize do
      date_last_run = last_run
      days_since = (Date.current - date_last_run.to_date).to_i

      # rubocop:disable Rails/SkipsModelValidations
      Racing::RacingStats.where(natural_energy_gain: "0.000").update_all(Arel.sql("natural_energy_gain = (FLOOR(RANDOM() * (444 - 220 + 1) + 220) / 100)"))
      Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where(race_metadata: { at_home: true }))
        .update_all(Arel.sql("energy = (energy + ((natural_energy_gain + energy_regain) * #{days_since})), fitness = (fitness - #{days_since})"))
      Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where.associated(:current_boarding))
        .update_all(Arel.sql("energy = (energy + ((natural_energy_gain + energy_regain) * #{days_since})), fitness = (fitness - #{days_since})"))
      Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where.missing(:current_boarding).where(race_metadata: { at_home: false }))
        .update_all(Arel.sql("energy = (energy + (energy_regain * #{days_since})), fitness = (fitness - #{days_since})"))
      Racing::RacingStats.where("energy > 100").update_all(energy: 100)
      Racing::RacingStats.where("energy < -100").update_all(energy: -100)
      Racing::RacingStats.where("fitness < 20").update_all(fitness: 20)
      Racing::RacingStats.where("fitness > 120").update_all(fitness: 120)
      Racing::RacingStats.where("xp_current > 100").update_all(xp_current: 100)
      Racing::HorseJockeyRelationship.where(experience: ...0).update_all("experience = abs(experience)")
      Racing::HorseJockeyRelationship.where(happiness: ...0).update_all("happiness = abs(happiness)")

      Racing::RacehorseMetadata
        .where(horse: Horses::Horse.racehorse.joins(:racing_stats).where("CEIL(racing_stats.energy * ((91 + FLOOR(RANDOM() * 20))/100)) <= ?", 40))
        .update_all(energy_grade: "F")
      Racing::RacehorseMetadata
        .where(horse: Horses::Horse.racehorse.joins(:racing_stats).where("CEIL(racing_stats.energy * ((91 + FLOOR(RANDOM() * 20))/100)) BETWEEN ? AND ?", 41, 60))
        .update_all(energy_grade: "D")
      Racing::RacehorseMetadata
        .where(horse: Horses::Horse.racehorse.joins(:racing_stats).where("CEIL(racing_stats.energy * ((91 + FLOOR(RANDOM() * 20))/100)) BETWEEN ? AND ?", 61, 70))
        .update_all(energy_grade: "C")
      Racing::RacehorseMetadata.joins(horse: :racing_stats)
        .where(horse: Horses::Horse.racehorse.joins(:racing_stats).where("CEIL(racing_stats.energy * ((91 + FLOOR(RANDOM() * 20))/100)) BETWEEN ? AND ?", 71, 90))
        .update_all(energy_grade: "B")
      Racing::RacehorseMetadata
        .where(horse: Horses::Horse.racehorse.joins(:racing_stats).where("CEIL(racing_stats.energy * ((91 + FLOOR(RANDOM() * 20))/100)) > ?", 90))
        .update_all(energy_grade: "A")

      Racing::RacehorseMetadata
        .where(horse: Horses::Horse.racehorse.joins(:racing_stats).where("CEIL(racing_stats.fitness * ((91 + FLOOR(RANDOM() * 20))/100)) <= ?", 40))
        .update_all(fitness_grade: "F")
      Racing::RacehorseMetadata
        .where(horse: Horses::Horse.racehorse.joins(:racing_stats).where("CEIL(racing_stats.fitness * ((91 + FLOOR(RANDOM() * 20))/100)) BETWEEN ? AND ?", 41, 60))
        .update_all(fitness_grade: "D")
      Racing::RacehorseMetadata
        .where(horse: Horses::Horse.racehorse.joins(:racing_stats).where("CEIL(racing_stats.fitness * ((91 + FLOOR(RANDOM() * 20))/100)) BETWEEN ? AND ?", 61, 70))
        .update_all(fitness_grade: "C")
      Racing::RacehorseMetadata.joins(horse: :racing_stats)
        .where(horse: Horses::Horse.racehorse.joins(:racing_stats).where("CEIL(racing_stats.fitness * ((91 + FLOOR(RANDOM() * 20))/100)) BETWEEN ? AND ?", 71, 90))
        .update_all(fitness_grade: "B")
      Racing::RacehorseMetadata
        .where(horse: Horses::Horse.racehorse.joins(:racing_stats).where("CEIL(racing_stats.fitness * ((91 + FLOOR(RANDOM() * 20))/100)) > ?", 90))
        .update_all(fitness_grade: "A")
      # rubocop:enable Rails/SkipsModelValidations
    end

    step :process do |step|
      Legacy::Horse.where(Status: 3).find_each(start: step.cursor) do |legacy_horse|
        horse_id = Horses::Horse.where(legacy_id: legacy_horse.ID).pick(:id)
        data = Racing::RacehorseMetadata.find_by(horse_id:)
        stats = Racing::RacingStats.find_by(horse_id:)
        if data
          legacy_horse.DisplayEnergy = data.energy_grade
          legacy_horse.DisplayFitness = data.fitness_grade
        end
        if stats
          legacy_horse.EnergyCurrent = stats.energy
          legacy_horse.Fitness = stats.fitness
        end
        legacy_horse.save
        horses += 1
        step.advance! from: legacy_horse.id
      end
    end

    step :update_views do
      Legacy::Record
        .connection
        .exec_query("
          UPDATE horse_racehorses_mv hv LEFT JOIN ff_horses h ON hv.horse_id = h.ID
          SET hv.energy_grade = h.DisplayEnergy, hv.fitness_grade = h.DisplayFitness
        ")
    end
    store_job_info(outcome: { horses: })
  end
end

