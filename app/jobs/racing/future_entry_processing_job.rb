class Racing::FutureEntryProcessingJob < ApplicationJob
  queue_as :latency_5m

  def perform
    return if run_today?

    result = Racing::FutureEntryProcessor.new.process_races
    store_job_info(outcome: result)
  end
end

