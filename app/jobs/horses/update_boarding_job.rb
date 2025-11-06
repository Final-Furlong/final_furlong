class Horses::UpdateBoardingJob < ApplicationJob
  queue_as :default

  def perform
    Horses::AutoBoardingUpdator.new.call
  end
end

