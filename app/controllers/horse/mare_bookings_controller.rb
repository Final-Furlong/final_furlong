module Horse
  class MareBookingsController < ApplicationController
    def index
      @horse = Horses::Horse.find(params[:horse_id])
      @bookings = policy_scope(Horses::Breeding.available_for_mare(@horse).ordered_by_status)
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

    def pick_date
      @horse = Horses::Horse.broodmare.includes(:next_foal).find(params[:horse_id])
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
      @horse = Horses::Horse.broodmare.find(params[:horse_id])
      authorize @horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @stud = Horses::Horse.stud.includes(:stud_options).find(params[:stud_id])
      @breeding = Horses::Breeding.new(mare: @horse, stud: @stud)
      authorize @breeding, :request_booking?
      @month = params[:month]
    end
  end
end

