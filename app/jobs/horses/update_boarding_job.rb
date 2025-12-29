class Horses::UpdateBoardingJob < ApplicationJob
  queue_as :default

  def perform
    result = Horses::AutoBoardingUpdater.new.call
    store_job_info(outcome: result)
  end
end

