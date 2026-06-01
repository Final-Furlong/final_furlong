# frozen_string_literal: true

class PopulateRaceSeriesWinners < ActiveRecord::Migration[8.1]
  def up
    Racing::RaceSeries.find_each do |series|
      (1996..Date.current.year.to_i).each do |year|
        race = series.first_race
        first_result = Racing::RaceResultHorse.joins(:race).merge(Racing::RaceResult.by_year(year)).find_by(finish_position: 1, race: { name: race.name })
        next unless first_result

        race = series.second_race
        second_result = Racing::RaceResultHorse.joins(:race).merge(Racing::RaceResult.by_year(year)).find_by(finish_position: 1, race: { name: race.name })
        next unless second_result
        next if first_result.horse_id != second_result.horse_id

        race = series.third_race
        third_result = Racing::RaceResultHorse.joins(:race).merge(Racing::RaceResult.by_year(year)).find_by(finish_position: 1, race: { name: race.name })
        next unless third_result
        next if first_result.horse_id != third_result.horse_id

        Racing::RaceSeriesWinner.find_or_create_by(
          year:,
          horse_id: first_result.horse_id,
          series:
        )
      end
    end
  end

  def down
    Racing::RaceSeriesWinner.delete_all
  end
end

