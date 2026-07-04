class Racing::RaceDayUpdaterJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  queue_as :latency_5m

  good_job_concurrency_rule(
    label: -> { arguments.first[:date] },
    total_limit: 2,
    perform_throttle: [1, 10.minutes],
    key: -> { self.class.name }
  )

  def perform(date:)
    result = {}
    Racing::RaceRecordUpdater.new.update_records(date:)
    injuries = Racing::InjuryUpdater.new.update_records(date:)
    claimed = Racing::ClaimsProcessor.new.process_claims(date:)
    result[:injuries] = injuries
    result[:claims] = claimed
    Racing::FutureRaceEntry.joins(:race).where(race: { date: }).delete_all
    Racing::RaceEntry.joins(:race).where(race: { date: }).delete_all
    Racing::RaceScheduleUpdater.new.update_schedule
    update_views
    # rubocop:disable Rails/SkipsModelValidations
    Racing::RacehorseMetadata.where(next_entry_date: ..date).update_all(next_entry_date: nil)
    swapped_to_sc = 0
    Horses::Horse::Racehorse.joins(:race_options).where(race_options: { racehorse_type: "flat" }).where(id: Racing::RaceResultHorse.joins(:race).merge(Racing::RaceResult.by_track("steeplechase")).select(:horse_id)).find_each do |horse|
      options = horse.race_options
      options.update_columns(racehorse_type: "jump")
      ::Horses::Event.create!(horse:, event_type: "switched_to_sc", date:)
      swapped_to_sc += 1
    end
    Horses::Horse::Racehorse.joins(:race_options).where(race_options: { racehorse_type: "jump" }).where.not(id: Racing::RaceResultHorse.joins(:race).merge(Racing::RaceResult.by_track("steeplechase")).select(:horse_id)).find_each do |horse|
      options = horse.race_options
      options.update_columns(racehorse_type: "flat")
    end
    # rubocop:enable Rails/SkipsModelValidations
    Horses::Horse::Racehorse.joins(:racehorse_metadata).where(racehorse_metadata: { next_entry_date: nil }).where.associated(:race_entries).find_each do |horse|
      horse.racehorse_metadata.update(next_entry_date: horse.race_entries.order(date: :asc).first&.date)
    end
    Horses::Horse::Racehorse.joins(:racehorse_metadata).where(racehorse_metadata: { next_entry_date: nil }).where.missing(:race_entries).where.associated(:future_race_entries).find_each do |horse|
      horse.racehorse_metadata.update(next_entry_date: horse.future_race_entries.order(date: :asc).first&.date)
    end
    Horses::Horse::Racehorse.joins(:racehorse_metadata).where(racehorse_metadata: { next_entry_date: nil }).where.missing(:race_entries).where.missing(:future_race_entries).find_each do |horse|
      horse.racehorse_metadata.update(next_entry_date: nil)
    end
    result[:new_jumpers] = swapped_to_sc
    store_job_info(outcome: result)
  end

  def update_views
    Racing::StableRaceRecord.refresh
    Racing::StableAnnualRaceRecord.refresh
    Racing::Qualifications::BreedersCupJuvenile.refresh
    Racing::Qualifications::BreedersCupJuvenileTurf.refresh
    Racing::Qualifications::BreedersCupJuvenileTurfFilly.refresh
    Racing::Qualifications::BreedersCupJuvenileFilly.refresh
    Racing::Qualifications::BreedersCupSprint.refresh
    Racing::Qualifications::BreedersCupTurfSprint.refresh
    Racing::Qualifications::BreedersCupFillyAndMareSprint.refresh
    Racing::Qualifications::BreedersCupMile.refresh
    Racing::Qualifications::BreedersCupDirtMile.refresh
    Racing::Qualifications::BreedersCupClassic.refresh
    Racing::Qualifications::BreedersCupTurf.refresh
    Racing::Qualifications::BreedersCupDistaff.refresh
    Racing::Qualifications::BreedersCupFillyAndMareTurf.refresh
    Racing::Qualifications::BreedersCupSteeplechaseSprint.refresh
    Racing::Qualifications::BreedersCupSteeplechaseClassic.refresh
    Racing::Qualifications::BreedersCupSteeplechaseEndurance.refresh
    Racing::Qualifications::BreedersCupSteeplechaseDistaff.refresh
    Racing::Qualifications::BreedersCupSteeplechaseDistaffEndurance.refresh
    Racing::Qualifications::BreedersSeries2yoDirt.refresh
    Racing::Qualifications::BreedersSeries2yoFilliesDirt.refresh
    Racing::Qualifications::BreedersSeries2yoTurf.refresh
    Racing::Qualifications::BreedersSeries2yoFilliesTurf.refresh
    Racing::Qualifications::BreedersSeries3yoDirt.refresh
    Racing::Qualifications::BreedersSeries3yoFilliesDirt.refresh
    Racing::Qualifications::BreedersSeries3yoTurf.refresh
    Racing::Qualifications::BreedersSeries3yoFilliesTurf.refresh
    Racing::Qualifications::BreedersSeries4yoDirt.refresh
    Racing::Qualifications::BreedersSeries4yoMaresDirt.refresh
    Racing::Qualifications::BreedersSeries4yoTurf.refresh
    Racing::Qualifications::BreedersSeries4yoMaresTurf.refresh
    Racing::Qualifications::BreedersSeriesSteeplechase.refresh
    Racing::Qualifications::BreedersSeriesFilliesSteeplechase.refresh
  end
end

