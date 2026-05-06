module Horse
  class PendingMareBookingsController < ApplicationController
    def index
      @horse = Horses::Horse.includes(:manager, next_foal: :stud).find(params[:horse_id])
      @bookings = policy_scope(Horses::Breeding.available_for_mare(@horse).ordered_by_status).includes(:slot, stud: :manager)
    end

    def new
      @horse = Horses::Horse.broodmare.includes(:next_foal, :manager).find(params[:horse_id])
      authorize @horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @stud = Horses::Horse.stud.includes(:stud_options).find(params[:stud_id])
      @breeding = Horses::Breeding.new(mare: @horse, stud: @stud)
      if (failure = policy(@breeding).request_booking_result.failure)
        if %i[approval_required outside_mare_limit_met_current_stable].include?(failure)
          render "horse/pending_mare_bookings/#{failure}", locals: { mare: @horse, stud: @stud }
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
      slot = ::Breeding::Slot.find(breeding_params[:slot_id])
      result = Horses::Broodmare::BookingRequester.new.request_booking(mare: @horse, stud: @stud, slot:, message: breeding_params[:message])
      if result.created?
        flash[:success] = t(".success", name: @stud.name)
        respond_to do |format|
          format.html { redirect_to horse_path(@horse) }
          format.turbo_stream { turbo_stream.action(:redirect, horse_path(@horse)) }
        end
      else
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("mare-booking-form", partial: "horse/pending_mare_bookings/approval_required", locals: { booking: result.booking, mare: @horse, stud: @stud })
          end
        end
      end
    end

    def destroy
      @horse = Horses::Horse.broodmare.includes(:manager).find(params[:horse_id])
      authorize @horse, :breed?, policy_class: CurrentStable::BroodmarePolicy
      @breeding = Horses::Breeding.where(mare: @horse).includes(:stud).find(params[:id])
      authorize @breeding

      name = @breeding.stud.name
      if @breeding.destroy!
        flash[:success] = t(".success", name:)
      else
        flash[:error] = t(".failure", name:)
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
      params.expect(horses_breeding: [:slot_id, :stud_id, :message])
    end
  end
end

