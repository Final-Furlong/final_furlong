class Racing::RaceTitleUpdaterJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :low_priority

  def perform(update_views: true)
    horses = 0

    step :initialize do
      if update_views
        Racing::RaceRecord.refresh
        Racing::LifetimeRaceRecord.refresh
        Racing::AnnualRaceRecord.refresh
      end
    end

    step :process do |step|
      Horses::Horse.racehorse.where.associated(:lifetime_race_record).find_each(start: step.cursor) do |horse|
        horse.update(title_abbr: horse.lifetime_race_record.title_abbreviation)
        horses += 1
        step.advance! from: horse.id
      end
    end
    store_job_info(outcome: { horses: })
  end
end

