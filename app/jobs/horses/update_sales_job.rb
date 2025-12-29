class Horses::UpdateSalesJob < ApplicationJob
  queue_as :default

  def perform
    result = Horses::AutoSaleOffersUpdater.new.call
    store_job_info(outcome: result)
  end
end

