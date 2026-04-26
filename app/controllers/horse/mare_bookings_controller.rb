module Horse
  class MareBookingsController < ApplicationController
    def index
      @horse = Horses::Horse.find(params[:horse_id])
      @bookings = policy_scope(Horses::Breeding.available_for_mare(@horse).ordered_by_status)
    end
  end
end

