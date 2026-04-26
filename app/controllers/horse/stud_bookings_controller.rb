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

      slot = ::Breeding::Slot.find(booking_params[:slot_id])
      @booking = Horses::Breeding.new(stud: @horse, slot:)
      authorize @booking, :create?
      result = Horses::Stud::BookingUpdater.new.update_booking(booking: @booking, stud: @horse, params: booking_params)
      if result.saved?
        flash[:success] = t(".success")
        redirect_to horse_path(@horse)
      else
        flash[:error] = t(".failure")
        respond_to do |format|
          format.html { render :new, status: :unprocessable_entity }

          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("booking-form", partial: "horse/stud_bookings/form", locals: { booking: result.booking, stud: @horse, error: result.error })
          end
        end
      end
    end

    def stable_dependent_fields
      @horse = Horses::Horse.find(params[:horse_id])
      authorize @horse, :manage_bookings?, policy_class: CurrentStable::StallionPolicy
      slot = ::Breeding::Slot.find(params[:slot_id])
      mare_stable = Account::Stable.find(params[:stable_id])

      @booking = Horses::Breeding.new(stud: @horse, slot:, stable: mare_stable)
      broodmares = Horses::Horse.broodmare.where(manager: mare_stable).order(name: :asc)

      render json: broodmares.map { |mare| { id: mare.id, name: mare.name } }
    rescue ActiveRecord::RecordNotFound
      render json: []
    end

    private

    def booking_params
      params.expect(horses_breeding: [:slot_id, :stable_id, :mare_id, :fee])
    end
  end
end

