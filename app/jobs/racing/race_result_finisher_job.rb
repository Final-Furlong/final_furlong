module Racing
  class RaceResultFinisherJob < ApplicationJob
    include GoodJob::ActiveJobExtensions::Concurrency

    queue_as :latency_5m

    good_job_concurrency_rule(
      label: -> { arguments.first[:date] },
      total_limit: 1
    )

    def perform(date:)
      Racing::RaceResultHorse.counter_culture_fix_counts
      Racing::RaceRecord.refresh
      Racing::LifetimeRaceRecord.refresh
      UpdateRaceResultHorseAbbreviationsJob.set(good_job_labels: [date]).perform_later(date:)
      Racing::RaceDayUpdaterJob.set(good_job_labels: [date]).perform_later(date:)
      Daily::ProcessFutureShipmentsJob.set(good_job_labels: [date]).perform_later(date:)
      User::SendDeveloperNotifications.call(title: "FF Races Finished", message: "Races finished running!")
    end
  end
end

