class Horses::UpdateAgesJob < ApplicationJob
  queue_as :latency_30s

  retry_on ActiveRecord::RecordInvalid

  def perform
    batch = GoodJob::Batch.new
    horses = 0
    Horses::Horse.find_each do |horse|
      batch.add(Horses::UpdateAgeJob.set(good_job_labels: [horse.id]).perform_later(id: horse.id))
      horses += 1
    end
    batch.enqueue
    store_job_info(outcome: { horses: })
  end
end

