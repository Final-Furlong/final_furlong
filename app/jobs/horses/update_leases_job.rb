class Horses::UpdateLeasesJob < ApplicationJob
  queue_as :latency_2m

  def perform
    return if run_today?

    result = Horses::Leasing::AutoOffersUpdater.new.call
    result2 = Horses::Leasing::AutoLeasesUpdater.new.call

    store_job_info(outcome: result.merge(result2))
  end
end

