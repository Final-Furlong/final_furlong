class Horses::UpdateBoardingJob < ApplicationJob
  queue_as :default

  def perform
    Horses::AutoBoardingUpdater.new.call
  end
end

