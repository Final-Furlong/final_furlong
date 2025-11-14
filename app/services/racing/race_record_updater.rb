module Racing
  class RaceRecordUpdater
    def update_records(date:)
      trigger_view_updates
      Horses::Horse.joins(:stud_foals).where(
        stud_foals: Horses::Horse.joins(:race_result_finishes).merge(Racing::RaceResultHorse.by_date(date))
      ).distinct.find_each do |sire|
        Horses::UpdateStudFoalRecordJob.perform_later(sire)
      end
      Horses::Horse.joins(:foals).where(
        foals: Horses::Horse.joins(:race_result_finishes).merge(Racing::RaceResultHorse.by_date(date))
      ).distinct.find_each do |dam|
        Horses::UpdateBroodmareFoalRecordJob.perform_later(dam)
      end
    end

    def trigger_view_updates
      Racing::AnnualRaceRecord.refresh
      Racing::LifetimeRaceRecord.refresh
    end
  end
end

