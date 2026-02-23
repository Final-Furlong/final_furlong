class Horses::UpdateLeasesJob < ApplicationJob
  queue_as :default

  def perform
    return if run_today?

    result = Horses::AutoLeaseOffersUpdater.new.call
    result2 = Horses::AutoLeasesUpdater.new.call

    store_job_info(outcome: result.merge(result2))
  end
end

