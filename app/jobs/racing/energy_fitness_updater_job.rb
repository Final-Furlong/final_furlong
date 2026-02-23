class Racing::EnergyFitnessUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    return if run_today?

    horses = 0
    Legacy::Horse.where(Status: 3).find_each do |legacy_horse|
      horse = Horses::Horse.find_by(legacy_id: legacy_horse.ID)
      next unless horse

      horse.racing_stats&.update(energy: legacy_horse.EnergyCurrent, fitness:
        legacy_horse.Fitness)
      horse.race_metadata&.update(energy_grade: legacy_horse.DisplayEnergy,
        fitness_grade: legacy_horse.DisplayFitness)
      horses += 1
    end
    missing_horses = Horses::Horse.racehorse.where.missing(:racing_stats).count
    missing_horses += Horses::Horse.racehorse.where.missing(:race_metadata).count
    store_job_info(outcome: { horses:, missing: missing_horses })
  end
end

