class Horses::CreateBabiesJob < ApplicationJob
  queue_as :latency_5m

  def perform
    batch = GoodJob::Batch.new

    breedings = 0
    Horses::Breeding.where(status: "bred").where.missing(:first_foal).find_each do |breeding|
      batch.add(Horses::CreateFoalJob.perform_later(id: breeding.id))
      breedings += 1
    end

    batch.enqueue
    store_job_info(outcome: { breedings: })
  end
end

