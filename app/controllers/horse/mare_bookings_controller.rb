module Horse
  class MareBookingsController < ApplicationController
    def index
      @horse = Horses::Horse.includes(:manager, next_foal: :stud).find(params[:horse_id])
      @bookings = policy_scope(Horses::Breeding.available_for_mare(@horse).ordered_by_status).includes(:slot, stud: :manager)
    end

    def new
      @horse = Horses::Horse::Broodmare.includes(:next_foal, :manager).find(params[:horse_id])
      authorize @horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @stud = Horses::Horse::Stud.left_outer_joins(:stud_nominations).includes(:stud_options, :nominations).merge(Horses::Stud::BreedersCupNomination.possible_current_year).find(params[:stud_id])
      @breeding = Horses::Breeding.new(mare: @horse, stud: @stud)
      if (failure = policy(@breeding).request_booking_result.failure)
        if %i[approval_required outside_mare_limit_met_current_stable].include?(failure)
          flash.now[:error] = t(".#{failure}") if failure.to_s == "outside_mare_limit_met_current_stable"
          render "horse/mare_bookings/approval_required", locals: { mare: @horse, stud: @stud }
        else
          flash[:error] = t(".#{failure}")
          authorize @breeding, :request_booking?
        end
      end
    end

    def create
      @horse = Horses::Horse::Broodmare.includes(:manager).find(params[:horse_id])
      authorize @horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @stud = Horses::Horse::Stud.includes(:stud_options).find(breeding_params[:stud_id])
      slot = ::Breeding::Slot.where(start_day: ..(breeding_params[:day])).order(start_day: :desc).find_by(month: breeding_params[:month])
      date = Date.new(Date.current.year, breeding_params[:month].to_i, breeding_params[:day].to_i)
      fee = (@horse.manager == @stud.manager) ? 0 : @stud.stud_options.stud_fee
      @breeding = Horses::Breeding.new(mare: @horse, stud: @stud, slot:, stable: @horse.manager, status: "approved", date:, year: date.year, fee:)
      if (failure = policy(@breeding).request_booking_result.failure)
        flash[:error] = t(".#{failure}")
      elsif @breeding.save
        flash[:success] = t(".success", name: @stud.name)
        respond_to do |format|
          format.html { redirect_to horse_path(@horse) }
          format.turbo_stream { turbo_stream.action(:redirect, horse_path(@horse)) }
        end
      else
        flash[:error] = t(".failure", name: @stud.name)
      end
    end

    def destroy
      @horse = Horses::Horse::Broodmare.includes(:manager).find(params[:horse_id])
      authorize @horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @breeding = Horses::Breeding.where(mare: @horse).includes(:stud).find(params[:id])
      authorize @breeding

      name = @breeding.stud.name
      result = Horses::Broodmare::BookingDeleter.new.delete_booking(booking: @breeding)
      if result.destroyed?
        flash[:success] = t(".success", name:)
      else
        flash[:error] = t(".failure", name:)
      end
      redirect_to horse_path(@horse)
    end

    def pick_date
      @horse = Horses::Horse::Broodmare.includes(:next_foal, :manager).find(params[:horse_id])
      authorize @horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @stud = Horses::Horse::Stud.includes(:stud_options).find(params[:stud_id])
      @breeding = Horses::Breeding.new(mare: @horse, stud: @stud)
      if (failure = policy(@breeding).request_booking_result.failure)
        if %i[approval_required outside_mare_limit_met_current_stable].include?(failure)
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

    def available_slots
      @horse = Horses::Horse::Broodmare.includes(:next_foal, :manager).find(params[:horse_id])
      authorize @horse, :create_booking?, policy_class: CurrentStable::BroodmarePolicy
      @stud = Horses::Horse::Stud.includes(:stud_options, :manager).find(params[:stud_id]) if params[:stud_id]
      slots = Horses::Breeding.new(mare: @horse, stud: @stud).options_for_mare_slot_select(@horse)

      render json: slots.map { |slot| { id: slot.last, display: slot.first } }
    rescue ActiveRecord::RecordNotFound
      render json: []
    end

    def load_slot_row
      @horse = Horses::Horse::Broodmare.includes(:next_foal, :manager).find(params[:horse_id])
      authorize @horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @stud = Horses::Horse::Stud.includes(:stud_options, :manager).find(params[:stud_id])
      @slot = ::Breeding::Slot.find(params[:slot_id])
      @breeding = Horses::Breeding.new(mare: @horse, stud: @stud, slot: @slot)
      if (failure = policy(@breeding).request_booking_result.failure)
        if %i[approval_required outside_mare_limit_met_current_stable].include?(failure)
          @template = "horse/mare_bookings/request_booking_button"
        else
          flash[:error] = t(".#{failure}")
          @template = "error"
        end
      else
        @template = "horse/mare_bookings/pick_date_button"
      end
    end

    def month_dependent_fields
      @horse = Horses::Horse::Broodmare.includes(:next_foal, :manager).find(params[:horse_id])
      authorize @horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @stud = Horses::Horse::Stud.includes(:stud_options, :manager).find(params[:stud_id])
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

