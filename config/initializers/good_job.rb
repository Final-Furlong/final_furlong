Rails.application.configure do
  config.good_job = {
    preserve_job_records: true,
    retry_on_unhandled_error: false,
    on_thread_error: ->(exception) { Sentry.capture_exception(exception) },
    queues: "latency_30s:2; latency_2m,latency_30s:2; *:2",
    max_threads: 5,
    enable_cron: true,
    cron_graceful_restart_period: 10.minutes,
    cron: {
      auto_workouts: {
        cron: "34 1 * * *",
        class: "Workouts::AutoWorkoutJob"
      },
      canary_health_check: {
        cron: "*/5 * * * *",
        class: "CanaryJob"
      },
      daily_update: {
        cron: "2 0 * * *",
        class: "Daily::MorningUpdatesJob"
      },
      horse_energy_fitness: {
        cron: "25 0 * * *",
        class: "Racing::EnergyFitnessUpdaterJob"
      },
      horse_natural_energy: {
        cron: "29 0 * * *",
        class: "Racing::NaturalEnergyUpdaterJob"
      },
      horse_racing_data: {
        cron: "7 1 * * *",
        class: "UpdateRacehorseStatsJob"
      },
      auction_create_monthly_auction: {
        cron: "1 0 1 1,3,4,5,7,9,10,12 *", # first day of every month that does not have another auction
        class: "Auctions::CreateMonthlyAuctionJob"
      },
      auction_create_two_year_old: {
        cron: "9 0 1 2 *", # first day of Feb
        class: "Auctions::CreateTwoYearOldAuctionJob"
      },
      auction_create_mixed: {
        cron: "9 0 1 6 *", # first day of June
        class: "Auctions::CreateMixedAuctionJob"
      },
      auction_create_select: {
        cron: "9 0 1 8 *", # first day of August
        class: "Auctions::CreateSelectAuctionJob"
      },
      auction_create_foal: {
        cron: "9 0 1 11 *", # first day of November
        class: "Auctions::CreateFoalAuctionJob"
      },
      auction_delete_empty: {
        cron: "45 23 * * *",
        class: "Daily::DeleteEmptyAuctionsJob"
      },
      auction_sales: {
        cron: "8 * * * *",
        class: "Auctions::TriggerSalesProcessingJob"
      },
      race_entry_filler: {
        cron: "14 9 * * 2,5", # Tues/Fri AM
        class: "Racing::RaceFiller::RaceJob"
      },
      race_entry_prerace: {
        cron: "14 10 * * 2,5", # Tues/Fri AM
        class: "Racing::PreRace::ProcessingJob"
      },
      race_runner: {
        cron: "14 11 * * 3,6", # Wed/Sat AM
        class: "Racing::TriggerRaceJob"
      },
      race_future_entry_process: {
        cron: "44 0 * * 1,2,4,5", # Mon/Tues/Fri/Sat AM
        class: "Racing::FutureEntryProcessingJob"
      },
      race_breeders_cup_selection: {
        cron: "14 11 * * 2,5", # Tues/Fri AM
        class: "Racing::BreedersCup::BulkSelectionJob"
      },
      race_runner: {
        cron: "14 10 * * 3,6", # Wed/Sat AM
        class: "Racing::TriggerRaceJob"
      }
    },
    dashboard_default_locale: :en
  }
end

