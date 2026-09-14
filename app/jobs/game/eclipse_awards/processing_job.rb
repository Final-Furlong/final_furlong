class Game::EclipseAwards::ProcessingJob < ApplicationJob
  queue_as :latency_30s

  retry_on ActiveRecord::RecordInvalid

  def perform(year: Date.current.year - 1)
    categories = 0
    batch = GoodJob::Batch.new
    Game::EclipseAwardContender::CATEGORIES.each do |category|
      next if Game::EclipseAward.exists?(category:, year:)
      next if Game::EclipseAwardContender.exists?(category:, year:)
      next if category.downcase == "horse"

      batch.add(Game::EclipseAwards::ContenderSelectionJob.perform_later(category:, year:))
      categories += 1
    end
    batch.enqueue
    if categories.positive?
      processing_day = (Time.current + (Config::Game.eclipse_award_voting_days + 1).days).beginning_of_day
      Game::EclipseAwards::EndOfVotingProcessingJob.set(wait_until: processing_day).perform_later(year:)
    end
    store_job_info(outcome: { categories: })
  end
end

