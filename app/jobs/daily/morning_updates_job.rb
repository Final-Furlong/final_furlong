class Daily::MorningUpdatesJob < ApplicationJob
  queue_as :latency_30s

  def perform
    return if run_today?

    classes = []
    class_list.each do |job_class|
      classes << job_class.to_s
      job_class.perform_later
    end
    date = Date.current
    Daily::ProcessFutureShipmentsJob.set(good_job_labels: [date]).perform_later(date:)
    classes << "Daily::ProcessFutureShipmentsJob"

    store_job_info(outcome: { classes: classes.count })
  end

  def class_list
    [Horses::UpdateBoardingJob, Horses::UpdateLeasesJob, Horses::UpdateSalesJob,
      Horses::NameHorsesJob, Horses::UpdateBabiesJob, Horses::GrowthJob,
      Horses::RetireMaresJob, Horses::KillMaresJob,
      Racing::RestDayUpdaterJob, Racing::WeatherForecastJob,
      Daily::DeleteReadNotificationsJob]
  end
end

