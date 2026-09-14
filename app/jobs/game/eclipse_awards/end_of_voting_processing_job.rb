class Game::EclipseAwards::EndOfVotingProcessingJob < ApplicationJob
  queue_as :latency_30s

  retry_on ActiveRecord::RecordInvalid

  def perform(year: Date.current.year - 1)
    return if run_today?

    batch = GoodJob::Batch.new
    categories = Set.new
    Game::EclipseAwardContender.voting_ended.select(:category).all.each do |record|
      categories.add(record.category)
    end
    categories.each do |category|
      batch.add(Game::EclipseAwards::EndOfVotingJob.perform_later(category:, year:))
    end
    batch.enqueue
    store_job_info(outcome: { categories: categories.count })
  end
end

