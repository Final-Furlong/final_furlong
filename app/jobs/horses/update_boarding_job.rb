class Horses::UpdateBoardingJob < ApplicationJob
  queue_as :default

  def perform
    return if run_today?

    result = Horses::AutoBoardingUpdater.new.call
    store_job_info(outcome: result)
  end
end

