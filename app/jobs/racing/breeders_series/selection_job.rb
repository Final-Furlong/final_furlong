class Racing::BreedersSeries::SelectionJob < ApplicationJob
  queue_as :latency_5m

  def perform(id:, series:)
    race = Racing::RaceSchedule.breeders_series.current_year.find_by(id:)
    return unless race
    deadline = race.entry_open_date - Config::Racing.breeders_series_deadline_days.days
    return unless Date.current <= deadline

    horses = 0

    return if Racing::BreedersSeriesPotentialEntry.exists?(first_race: race)

    result = Racing::BreedersSeriesEntrySelector.new.select_horses(race:, series:)
    horses + result.horses
  end
end

