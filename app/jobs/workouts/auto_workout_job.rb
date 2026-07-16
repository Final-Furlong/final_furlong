class Workouts::AutoWorkoutJob < ApplicationJob
  queue_as :latency_5m

  retry_on FloatDomainError

  def perform(date: Date.current)
    return if run_today?(date:)

    yesterday = date - 1.day
    queued = 0
    weekday = yesterday.strftime("%A").downcase
    batch = GoodJob::Batch.new
    Racing::TrainingSchedule.with_activities(weekday).distinct.find_each do |schedule|
      schedule.send("#{weekday}_activities")
      schedule.training_schedule_horses.includes(:horse).where(horse: { state: "active", type: "Horses::Horse::Racehorse" }).find_each do |training_horse|
        horse = training_horse.horse
        batch.add(Workouts::ProcessWorkoutJob.perform_later(schedule_id: schedule.id, horse_id: horse.id, date: yesterday))
        queued += 1
      end
    end
    batch.enqueue(on_finish: Workouts::NotifyWorkoutsJob, queued:)
    store_job_info(outcome: { queued: })
  end
end

