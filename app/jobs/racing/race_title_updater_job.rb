class Racing::RaceTitleUpdaterJob < ApplicationJob
  queue_as :latency_5m

  def perform(update_views: true)
    horses = 0

    if update_views
      Racing::RaceRecord.refresh
      Racing::AnnualRaceRecord.refresh
      Racing::LifetimeRaceRecord.refresh
    end

    Horses::Horse.racehorse.joins(:lifetime_race_record).where.not(lifetime_race_record: { title_abbreviation: [nil, ""] }).find_each do |horse|
      horse.update(title_abbr: horse.lifetime_race_record.title_abbreviation)
      horses += 1 if horse.changed?
    end
    store_job_info(outcome: { horses: })
  end
end

