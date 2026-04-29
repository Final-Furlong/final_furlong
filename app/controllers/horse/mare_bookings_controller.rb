module Horse
  class MareBookingsController < ApplicationController
    def index
      @horse = Horses::Horse.includes(:manager, next_foal: :stud).find(params[:horse_id])
      @bookings = policy_scope(Horses::Breeding.available_for_mare(@horse).ordered_by_status).includes(:slot, stud: :manager)
    end

    def new
      @horse = Horses::Horse.broodmare.includes(:next_foal).find(params[:horse_id])
      authorize @horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @stud = Horses::Horse.stud.includes(:stud_options).find(params[:stud_id])
      @breeding = Horses::Breeding.new(mare: @horse, stud: @stud)
      if (failure = policy(@breeding).request_booking_result.failure)
        if %i[approval_required outside_mare_limit_met_current_stable].include?(failure)
          render "horse/mare_bookings/#{failure}", locals: { mare: @horse, stud: @stud }
        else
          flash[:error] = t(".#{failure}")
          authorize @breeding, :request_booking?
        end
      end
    end

    def create
      @horse = Horses::Horse.broodmare.includes(:manager).find(params[:horse_id])
      authorize @horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @stud = Horses::Horse.stud.includes(:stud_options).find(breeding_params[:stud_id])
      slot = ::Breeding::Slot.where(start_day: ..(breeding_params[:day])).order(start_day: :desc).find_by(month: breeding_params[:month])
      date = Date.new(Date.current.year, breeding_params[:month].to_i, breeding_params[:day].to_i)
      @breeding = Horses::Breeding.new(mare: @horse, stud: @stud, slot:, stable: @horse.manager, status: "approved", date:, year: date.year)
      if (failure = policy(@breeding).request_booking_result.failure)
        flash[:error] = t(".#{failure}")
      elsif @breeding.save!
        flash[:success] = t(".success", name: @stud.name)
      else
        flash[:error] = t(".failure", name: @stud.name)
      end
      redirect_to horse_path(@horse)
    end

    def pick_date
      @horse = Horses::Horse.broodmare.includes(:next_foal, :manager).find(params[:horse_id])
      authorize @horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @stud = Horses::Horse.stud.includes(:stud_options).find(params[:stud_id])
      @breeding = Horses::Breeding.new(mare: @horse, stud: @stud)
      if (failure = policy(@breeding).request_booking_result.failure)
        if %i[approval_required outside_mare_limit_met_current_stable].include?(failure)
          # render approval form
          pd failure
          respond_to do |format|
            format.turbo_stream { render failure.to_sym }
          end
          return
        else
          flash[:error] = t(".#{failure}")
          authorize @breeding, :request_booking?
        end
      end

      respond_to do |format|
        format.turbo_stream { render :pick_date }
      end
    end

    def month_dependent_fields
      @horse = Horses::Horse.broodmare.includes(:next_foal, :manager).find(params[:horse_id])
      authorize @horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @stud = Horses::Horse.stud.includes(:stud_options, :manager).find(params[:stud_id])
      @breeding = Horses::Breeding.new(mare: @horse, stud: @stud)
      authorize @breeding, :request_booking?
      @month = params[:month]
    end

    private

    def breeding_params
      params.expect(horses_breeding: [:stud_id, :month, :day])
    end
  end
end

