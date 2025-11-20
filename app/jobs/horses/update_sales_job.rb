class Horses::UpdateSalesJob < ApplicationJob
  queue_as :default

  def perform
    Horses::AutoSalesOffersUpdater.new.call
  end
end

