class Horses::UpdateBoardingJob < ApplicationJob
  queue_as :latency_2m

  def perform
    return if run_today?

    result = Horses::Racehorse::AutoBoardingUpdater.new.call
    store_job_info(outcome: result)
  end
end

