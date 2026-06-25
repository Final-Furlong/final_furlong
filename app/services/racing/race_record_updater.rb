module Racing
  class RaceRecordUpdater
    def update_records(date:)
      trigger_view_updates
      Racing::RaceTitleUpdaterJob.perform_later(update_views: false)
    end

    def trigger_view_updates
      Racing::RaceRecord.refresh
      Racing::LifetimeRaceRecord.refresh
      Racing::AnnualRaceRecord.refresh
      Horses::Broodmare::FoalRecord.refresh
      Horses::Stud::FoalRecord.refresh
    end
  end
end

