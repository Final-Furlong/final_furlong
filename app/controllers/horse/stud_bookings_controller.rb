module Horse
  class StudBookingsController < ApplicationController
    def index
      @horse = Horses::Horse.find(params[:horse_id])
      @bookings = policy_scope(Horses::Breeding.where(stud: @horse))
    end

    def new
      @horse = Horses::Horse.find(params[:horse_id])
      authorize @horse, :manage_bookings?, policy_class: CurrentStable::StallionPolicy

      slot = ::Breeding::Slot.find(params[:slot_id])
      @booking = Horses::Breeding.new(stud: @horse, slot:)
      authorize @booking, :create?
    end

    def create
      @horse = Horses::Horse.find(params[:horse_id])
      authorize @horse, :manage_bookings?, policy_class: CurrentStable::StallionPolicy
    end
  end
end

