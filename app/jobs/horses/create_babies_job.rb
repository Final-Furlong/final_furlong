class Horses::CreateBabiesJob < ApplicationJob
  queue_as :latency_5m

  def perform
    batch = GoodJob::Batch.new
    batch.properties = { starting_foal_count: Horses::Breeding.where(status: "bred", year: Date.current.year).where.associated(:first_foal).count }

    Horses::Breeding.where(status: "bred", year: Date.current.year).where.missing(:first_foal).find_each do |breeding|
      batch.add(Horses::CreateFoalJob.perform_later(id: breeding.id))
    end

    batch.enqueue(on_finish: ::Horses::CreateBabiesCallbackJob)
  end
end

