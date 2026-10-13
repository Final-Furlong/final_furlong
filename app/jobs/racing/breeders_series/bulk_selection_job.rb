class Racing::BreedersSeries::BulkSelectionJob < ApplicationJob
  queue_as :latency_30s

  def perform
    bs_race = Racing::RaceSchedule.breeders_series.current_year.first
    return unless bs_race
    deadline = bs_race.entry_open_date - Config::Racing.breeders_series_deadline_days.days
    return unless Date.current == deadline

    horses = 0
    races = 0
    series_names = []

    batch = GoodJob::Batch.new
    Racing::RaceSchedule.breeders_series.current_year.includes(:track_surface).find_each do |race|
      series_name = if race.track_surface.surface.steeplechase?
        race.male_only? ? "Steeplechase" : "Steeplechase Filly"
      elsif race.age == "2"
        if race.track_surface.surface.dirt?
          race.male_only? ? "2yo Dirt" : "2yo Filly Dirt"
        else
          race.male_only? ? "2yo Turf" : "2yo Filly Turf"
        end
      elsif race.age == "3"
        if race.track_surface.surface.dirt?
          race.male_only? ? "3yo Dirt" : "3yo Filly Dirt"
        else
          race.male_only? ? "3yo Turf" : "3yo Filly Turf"
        end
      elsif race.track_surface.surface.dirt?
        race.male_only? ? "4yo Dirt" : "4yo Mare Dirt"
      else
        race.male_only? ? "4yo Turf" : "4yo Mare Turf"
      end

      next if series_names.include?(series_name)

      batch.add(Racing::BreedersSeries::SelectionJob.perform_later(id: race.id, series: series_name))
      series_names << series_name
      races += 1
    end
    batch.enqueue
    store_job_info(outcome: { horses:, races: })
  end
end

