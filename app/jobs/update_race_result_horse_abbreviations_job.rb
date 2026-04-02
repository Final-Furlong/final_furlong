class UpdateRaceResultHorseAbbreviationsJob < ApplicationJob
  include ActiveJob::Continuable

  queue_as :low_priority

  def perform(date: nil)
    step :process do |step|
      query = if date.present?
        Racing::RacehorseMetadata.joins(horse: { race_result_finishes: :race }).where(race_results: { date: })
      else
        Racing::RacehorseMetadata.all
      end
      query.find_each(start: step.cursor) do |race_metadata|
        horse = race_metadata.horse
        recent_race = horse.race_result_finishes.order(id: :desc).first
        next unless recent_race

        race_metadata.update(latest_result_abbreviation: recent_race.result_abbreviation)
      end
    end
  end
end

