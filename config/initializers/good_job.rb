Rails.application.configure do
  config.good_job = {
    preserve_job_records: true,
    retry_on_unhandled_error: false,
    on_thread_error: ->(exception) { Rails.error.report(exception) },
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
      horse_legacy_migrate: {
        cron: "*/30 * * * *",
        class: "UpdateLegacyHorsesJob"
      },
      horse_legacy_stats_migrate: {
        cron: "*/35 * * * *",
        class: "UpdateLegacyRacingStatsJob"
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
        cron: "8 */12 * * *",
        class: "Auctions::ProcessSalesJob"
      },
      race_entry_filler: {
        cron: "14 1 * * 2,5", # Tues/Sat AM
        class: "Racing::RaceFillerJob"
      },
      race_entry_prerace: {
        cron: "14 2 * * 2,5", # Tues/Sat AM
        class: "Racing::PreRaceJob"
      },
      race_future_entry_process: {
        cron: "44 0 * * 1,2,4,5", # Mon/Tues/Fri/Sat AM
        class: "Racing::FutureEntryProcessingJob"
      }
    },
    dashboard_default_locale: :en
  }
end

