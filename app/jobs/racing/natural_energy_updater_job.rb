class Racing::NaturalEnergyUpdaterJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :default

  def perform
    return if run_today?

    horses = 0

    step :initialize do
      date_last_run = last_run || Date.yesterday
      days_since = (Date.current - date_last_run.to_date).to_i

      total_loss = 0.1 * days_since
      total_loss = 1 if total_loss > 1

      ActiveRecord::Base.transaction do
        # rubocop:disable Rails/SkipsModelValidations
        Racing::RacingStats
          .where(horse: Horses::Horse.racehorse.joins(:race_metadata).where.missing(:current_boarding).where(race_metadata: { at_home: false }))
          .update_all(Arel.sql("natural_energy_current = (natural_energy_current - #{total_loss})"))

        Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where(race_metadata: { at_home: true }))
          .where(natural_energy_current: ..0)
          .update_all(Arel.sql("natural_energy_current = (natural_energy_current + (natural_energy_gain * 10 * #{total_loss}))"))
        Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where(race_metadata: { at_home: true }))
          .where("natural_energy_current BETWEEN ? AND ?", 1, 20)
          .update_all(Arel.sql("natural_energy_current = (natural_energy_current + (natural_energy_gain * 5 * #{total_loss}))"))
        Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where(race_metadata: { at_home: true }))
          .where("natural_energy_current BETWEEN ? AND ?", 21, 40)
          .update_all(Arel.sql("natural_energy_current = (natural_energy_current + (natural_energy_gain * 4 * #{total_loss}))"))
        Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where(race_metadata: { at_home: true }))
          .where("natural_energy_current BETWEEN ? AND ?", 41, 60)
          .update_all(Arel.sql("natural_energy_current = (natural_energy_current + (natural_energy_gain * 3 * #{total_loss}))"))
        Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where(race_metadata: { at_home: true }))
          .where("natural_energy_current BETWEEN ? AND ?", 61, 80)
          .update_all(Arel.sql("natural_energy_current = (natural_energy_current + (natural_energy_gain * 2 * #{total_loss}))"))
        Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where(race_metadata: { at_home: true }))
          .where("natural_energy_current > ?", 80)
          .update_all(Arel.sql("natural_energy_current = (natural_energy_current + (natural_energy_gain * #{total_loss}))"))

        Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where.associated(:current_boarding))
          .where(natural_energy_current: ..0)
          .update_all(Arel.sql("natural_energy_current = (natural_energy_current + (natural_energy_gain * 5 * #{total_loss}))"))
        Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where.associated(:current_boarding))
          .where("natural_energy_current BETWEEN ? AND ?", 1, 20)
          .update_all(Arel.sql("natural_energy_current = (natural_energy_current + (natural_energy_gain * 2.5 * #{total_loss}))"))
        Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where.associated(:current_boarding))
          .where("natural_energy_current BETWEEN ? AND ?", 21, 40)
          .update_all(Arel.sql("natural_energy_current = (natural_energy_current + (natural_energy_gain * 2 * #{total_loss}))"))
        Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where.associated(:current_boarding))
          .where("natural_energy_current BETWEEN ? AND ?", 41, 60)
          .update_all(Arel.sql("natural_energy_current = (natural_energy_current + (natural_energy_gain * 1.5 * #{total_loss}))"))
        Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where.associated(:current_boarding))
          .where("natural_energy_current BETWEEN ? AND ?", 61, 80)
          .update_all(Arel.sql("natural_energy_current = (natural_energy_current + (natural_energy_gain * #{total_loss}))"))
        Racing::RacingStats.where(horse: Horses::Horse.racehorse.joins(:race_metadata).where.associated(:current_boarding))
          .where("natural_energy_current > ?", 80)
          .update_all(Arel.sql("natural_energy_current = (natural_energy_current + (natural_energy_gain * 0.5 *  #{total_loss}))"))

        Racing::RacingStats.where("natural_energy_current > 100").update_all(natural_energy_current: 100)
        # rubocop:enable Rails/SkipsModelValidations
      end
    end

    step :process do |step|
      Legacy::Horse.where(Status: 3).find_each(start: step.cursor) do |legacy_horse|
        horse_id = Horses::Horse.where(legacy_id: legacy_horse.ID).pick(:id)
        stats = Racing::RacingStats.find_by(horse_id:)
        if stats
          legacy_horse.NaturalEnergy = stats.natural_energy_current
        end
        legacy_horse.save
        horses += 1
        step.advance! from: legacy_horse.id
      end
    end
    store_job_info(outcome: { horses: })
  end
end

