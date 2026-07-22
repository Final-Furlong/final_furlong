module Racing
  class RaceResultFinisherJob < ApplicationJob
    include GoodJob::ActiveJobExtensions::Concurrency

    queue_as :latency_5m

    good_job_concurrency_rule(
      label: -> { arguments.first[:date] },
      total_limit: 1
    )

    def perform(date:)
      require "rake"
      FinalFurlong::Application.load_tasks
      system 'bundle exec rake maintenance:start reason="Finalizing today\'s results. This should take approximately 10 minutes."'
      Racing::RaceResultHorse.counter_culture_fix_counts
      Racing::RaceRecord.refresh
      Racing::LifetimeRaceRecord.refresh

      batch = GoodJob::Batch.new
      batch.add(UpdateRaceResultHorseAbbreviationsJob.perform_later(date:))
      batch.add(Racing::RaceDayUpdaterJob.perform_later(date:))
      batch.add(Daily::ProcessFutureShipmentsJob.perform_later(date:))
      batch.enqueue(on_finish: Racing::NotifyFinishedJob, date:)
    end
  end
end

