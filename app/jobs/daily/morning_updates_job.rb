class Daily::MorningUpdatesJob < ApplicationJob
  queue_as :default

  def perform
    Daily::CreateActivationsJob.perform_later
    Horses::UpdateBoardingJob.perform_later
    Horses::UpdateLeasesJob.perform_later
    Horses::UpdateSalesJob.perform_later
  end
end

