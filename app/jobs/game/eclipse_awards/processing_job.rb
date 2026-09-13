class Game::EclipseAwards::ProcessingJob < ApplicationJob
  queue_as :latency_30s

  retry_on ActiveRecord::RecordInvalid

  def perform(year: Date.current.year - 1)
    categories = 0
    batch = GoodJob::Batch.new
    Game::EclipseAwardContender::CATEGORIES.each do |category|
      next if Game::EclipseAward.exists?(category:, year:)
      next if category.downcase == "horse"

      batch.add(Game::EclipseAwards::ContenderSelectionJob.perform_later(category:, year:))
      categories += 1
    end
    batch.enqueue
    store_job_info(outcome: { categories: })
  end
end

