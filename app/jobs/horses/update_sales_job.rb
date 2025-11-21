class Horses::UpdateSalesJob < ApplicationJob
  queue_as :default

  def perform
    Horses::AutoSaleOffersUpdater.new.call
  end
end

