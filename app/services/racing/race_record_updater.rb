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
      titles_updated = 0
      Horses::Horse.joins(:race_result_finishes, :lifetime_race_record).merge(Racing::RaceResultHorse.by_date(date)).where.not(lifetime_race_record: { title_abbreviation: nil }).distinct.find_each do |horse|
        lrr = horse.lifetime_race_record
        horse.update(title_abbr: lrr.title_abbreviation)
        titles_updated += 1
      end
      { studs_updated:, mares_updated:, titles_updated: }
    end

    def trigger_view_updates
      Racing::RaceRecord.refresh
      Racing::LifetimeRaceRecord.refresh
      Racing::AnnualRaceRecord.refresh
    end
  end
end

