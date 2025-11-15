class Horses::UpdateLeasesJob < ApplicationJob
  queue_as :default

  def perform
    Horses::AutoLeaseOffersUpdater.new.call
    Horses::AutoLeasesUpdater.new.call
  end
end

