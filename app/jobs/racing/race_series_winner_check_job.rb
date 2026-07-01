class Racing::RaceSeriesWinnerCheckJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  queue_as :latency_30s

  good_job_concurrency_rule(
    label: -> { arguments.first[:race_id] },
    total_limit: 1,
    key: -> { self.class.name }
  )

  def perform(race_id:)
    race = Racing::RaceSchedule.find(race_id)
    series = Racing::RaceSeries.find_by(third_race: race)
    return unless series

    third_result = Racing::RaceResultHorse.joins(:race).find_by(finish_position: 1, race:)

    year = race.date.year
    first_race = series.first_race
    first_result = Racing::RaceResultHorse.joins(:race).merge(Racing::RaceResult.by_year(year)).find_by(finish_position: 1, race: { name: first_race.name })
    return unless first_result
    return if first_result.horse_id != third_result.horse_id

    second_race = series.second_race
    second_result = Racing::RaceResultHorse.joins(:race).merge(Racing::RaceResult.by_year(year)).find_by(finish_position: 1, race: { name: second_race.name })
    return unless second_result
    return if second_result.horse_id != third_result.horse_id

    Racing::RaceSeriesWinner.find_or_create_by(
      year:,
      horse_id: third_result.horse_id,
      series:
    )
  end
end

