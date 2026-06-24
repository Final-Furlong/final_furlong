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
        class: "Workouts::AutoWorkoutJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      canary_health_check: {
        cron: "*/5 * * * *",
        class: "CanaryJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      daily_update: {
        cron: "17 0 * * *",
        class: "Daily::MorningUpdatesJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      yearly_update: {
        cron: "1 0 1 1 *",
        class: "Yearly::StartOfYearJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      horse_energy_fitness: {
        cron: "25 0 * * *",
        class: "Racing::EnergyFitnessUpdaterJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      horse_natural_energy: {
        cron: "29 0 * * *",
        class: "Racing::NaturalEnergyUpdaterJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      horse_racing_data: {
        cron: "7 1 * * *",
        class: "UpdateRacehorseStatsJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      auction_create_monthly_auction: {
        cron: "1 0 1 1,3,4,5,7,9,10,12 *", # first day of every month that does not have another auction
        class: "Auctions::CreateMonthlyAuctionJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      auction_create_two_year_old: {
        cron: "9 0 1 2 *", # first day of Feb
        class: "Auctions::CreateTwoYearOldAuctionJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      auction_create_mixed: {
        cron: "9 0 1 6 *", # first day of June
        class: "Auctions::CreateMixedAuctionJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      auction_create_select: {
        cron: "9 0 1 8 *", # first day of August
        class: "Auctions::CreateSelectAuctionJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      auction_create_foal: {
        cron: "9 0 1 11 *", # first day of November
        class: "Auctions::CreateFoalAuctionJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      auction_delete_empty: {
        cron: "45 23 * * *",
        class: "Daily::DeleteEmptyAuctionsJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      auction_sales: {
        cron: "8 * * * *",
        class: "Auctions::TriggerSalesProcessingJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      race_entry_filler: {
        cron: "14 9 * * 2,5", # Tues/Fri AM
        class: "Racing::RaceFiller::RaceJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      race_entry_prerace: {
        cron: "14 10 * * 2,5", # Tues/Fri AM
        class: "Racing::PreRace::ProcessingJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      race_runner: {
        cron: "14 11 * * 3,6", # Wed/Sat AM
        class: "Racing::TriggerRaceJob",
        kwargs: -> { { date: Date.current } },
        set: -> { { good_job_label: [Date.current] } },
        enabled_by_default: -> { Rails.env.production? }
      },
      race_future_entry_process: {
        cron: "44 0 * * 1,2,4,5", # Mon/Tues/Fri/Sat AM
        class: "Racing::FutureEntryProcessingJob",
        enabled_by_default: -> { Rails.env.production? }
      },
      race_breeders_cup_selection: {
        cron: "14 11 * * 2,5", # Tues/Fri AM
        class: "Racing::BreedersCup::BulkSelectionJob",
        enabled_by_default: -> { Rails.env.production? }
      }
    },
    dashboard_default_locale: :en
  }
end

