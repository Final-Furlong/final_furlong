class Daily::MorningUpdatesJob < ApplicationJob
  queue_as :default

  def perform
    Horses::UpdateBoardingJob.perform_later
    Horses::UpdateLeasesJob.perform_later
    Horses::UpdateSalesJob.perform_later
  end
end

