class UpdateRaceResultHorseAbbreviationsJob < ApplicationJob
  queue_as :latency_5m

  def perform(date: nil)
    query = if date.present?
      Racing::RacehorseMetadata.joins(horse: { race_result_finishes: :race }).where(race_results: { date: })
    else
      Racing::RacehorseMetadata.all
    end
    horses = 0
    query.find_each do |race_metadata|
      horse = race_metadata.horse
      recent_race = horse.race_result_finishes.order(id: :desc).first
      next unless recent_race

      race_metadata.update(latest_result_abbreviation: recent_race.result_abbreviation)
      horses += 1
    end
    store_job_info(outcome: { horses: })
  end
end

