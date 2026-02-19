class Daily::MorningUpdatesJob < ApplicationJob
  queue_as :default

  def perform
    classes = []
    class_list.each do |job_class|
      classes << job_class.to_s
      job_class.perform_later
    end

    store_job_info(outcome: { classes: classes.count })
  end

  def class_list
    [Daily::CreateActivationsJob, Horses::UpdateBoardingJob,
      Horses::UpdateLeasesJob, Horses::UpdateSalesJob,
      UpdateLegacyWorkoutsJob, Horses::NameHorsesJob,
      Horses::UpdateBabiesJob, Horses::RetireMaresJob,
      Horses::KillMaresJob]
  end
end

