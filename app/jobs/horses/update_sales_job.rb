class Horses::UpdateSalesJob < ApplicationJob
  queue_as :latency_2m

  def perform
    return if run_today?

    result = Horses::Selling::AutoOffersUpdater.new.call
    store_job_info(outcome: result)
  end
end

