class Racing::RaceTitleUpdaterJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :latency_5m

  def perform(update_views: true)
    horses = 0

    step :initialize do
      if update_views
        Racing::RaceRecord.refresh
        Racing::AnnualRaceRecord.refresh
        Racing::LifetimeRaceRecord.refresh
      end
    end

    step :process do |step|
      Horses::Horse.racehorse.joins(:lifetime_race_record).where.not(lifetime_race_record: { title_abbr: [nil, ""] }).find_each(start: step.cursor) do |horse|
        horse.update(title_abbr: horse.lifetime_race_record.title_abbreviation)
        horses += 1
        step.advance! from: horse.id
      end
    end
    store_job_info(outcome: { horses: })
  end
end

