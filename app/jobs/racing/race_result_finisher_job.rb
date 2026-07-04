module Racing
  class RaceResultFinisherJob < ApplicationJob
    include GoodJob::ActiveJobExtensions::Concurrency

    queue_as :latency_5m

    good_job_concurrency_rule(
      label: -> { arguments.first[:date] },
      total_limit: 1,
      key: -> { self.class.name }
    )

    def perform(date:)
      Racing::RaceResultHorse.counter_culture_fix_counts
      Racing::RaceRecord.refresh
      Racing::LifetimeRaceRecord.refresh
      UpdateRaceResultHorseAbbreviationsJob.set(good_job_labels: [date], wait: 1.minute).perform_later(date:)
      Racing::RaceDayUpdaterJob.set(good_job_labels: [date], wait: 2.minutes).perform_later(date:)
      Daily::ProcessFutureShipmentsJob.set(good_job_labels: [date], wait: 5.minutes).perform_later(date:)
      User::SendDeveloperNotifications.call(title: "FF Races Finished", message: "Races finished running!")
    end
  end
end

