class Daily::MorningUpdatesJob < ApplicationJob
  queue_as :default

  def perform
    classes = []
    [Daily::CreateActivationsJob, Horses::UpdateBoardingJob,
      Horses::UpdateLeasesJob, Horses::UpdateSalesJob].each do |job_class|
      classes << job_class.to_s
      job_class.perform_later
    end

    store_job_info(outcome: { classes: classes.join(",") })
  end
end

