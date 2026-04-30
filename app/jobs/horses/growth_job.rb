class Horses::GrowthJob < ApplicationJob
  queue_as :latency_2m

  def perform
    return if run_today?
    batch = GoodJob::Batch.new

    horses_grown = 0
    Horses::Horse.born.not_stillborn.joins(:racing_stats).includes(:racing_stats, :appearance).merge(::Racing::RacingStats.not_peaked).find_each do |horse|
      batch.add(Horses::GrowHorseJob.perform_later(id: horse.id))
      horses_grown += 1
    end

    # rubocop:disable Rails/SkipsModelValidations
    fully_grown = Horses::Appearance.where(horse: Horses::Horse.born.not_stillborn.joins(:racing_stats).merge(::Racing::RacingStats.peaked)).update_all("current_height = max_height")
    # rubocop:enable Rails/SkipsModelValidations

    batch.enqueue
    store_job_info(outcome: { horses_grown:, fully_grown: })
  end
end

