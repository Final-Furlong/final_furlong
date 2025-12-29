module Racing
  class RaceRecordUpdater
    def update_records(date:)
      trigger_view_updates
      studs_updated = 0
      Horses::Horse.joins(:stud_foals).where(
        stud_foals: Horses::Horse.joins(:race_result_finishes).merge(Racing::RaceResultHorse.by_date(date))
      ).distinct.find_each do |sire|
        Horses::UpdateStudFoalRecordJob.perform_later(sire)
        studs_updated += 1
      end
      mares_updated = 0
      Horses::Horse.joins(:foals).where(
        foals: Horses::Horse.joins(:race_result_finishes).merge(Racing::RaceResultHorse.by_date(date))
      ).distinct.find_each do |dam|
        Horses::UpdateBroodmareFoalRecordJob.perform_later(dam)
        mares_updated += 1
      end
      { studs_updated:, mares_updated: }
    end

    def trigger_view_updates
      Racing::AnnualRaceRecord.refresh
      Racing::LifetimeRaceRecord.refresh
    end
  end
end

