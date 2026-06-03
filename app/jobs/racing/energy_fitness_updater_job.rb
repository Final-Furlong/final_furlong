class Racing::EnergyFitnessUpdaterJob < ApplicationJob
  queue_as :latency_5m

  def perform
    return if run_today?

    horses = 0

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
    store_job_info(outcome: { horses: })
  end
end

