module Horse
  class StudBookingsController < ApplicationController
    def index
      @horse = Horses::Horse.includes(:manager).find(params[:horse_id])
      @bookings = policy_scope(Horses::Breeding.where(stud: @horse))
    end

    def new
      @horse = Horses::Horse.find(params[:horse_id])
      authorize @horse, :manage_bookings?, policy_class: CurrentStable::StallionPolicy

      slot = ::Breeding::Slot.find(params[:slot_id])
      @booking = Horses::Breeding.new(stud: @horse, slot:)
      authorize @booking, :create?
    end

    def edit
      @horse = Horses::Horse.includes(:manager, :stud_options).find(params[:horse_id])
      authorize @horse, :manage_bookings?, policy_class: CurrentStable::StallionPolicy

      @booking = Horses::Breeding.includes(:slot, :mare, stud: :manager).where(stud: @horse).find(params[:id])
      authorize @booking, :update?
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

    def update
      @horse = Horses::Horse.find(params[:horse_id])
      authorize @horse, :manage_bookings?, policy_class: CurrentStable::StallionPolicy

      @booking = Horses::Breeding.find(booking_params[:booking_id])
      authorize @booking, :update?
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

    def destroy
      @horse = Horses::Horse::Stud.includes(:manager).find(params[:horse_id])
      authorize @horse, :manage_bookings?, policy_class: CurrentStable::StallionPolicy
      @breeding = Horses::Breeding.where(stud: @horse).includes(:mare, :stable).find(params[:id])
      authorize @breeding

      name = @breeding.mare ? @breeding.mare.name : @breeding.stable.name
      result = Horses::Stud::BookingDeleter.new.delete_booking(booking: @breeding)
      if result.destroyed?
        flash[:success] = t(".success", name:)
      else
        flash[:error] = t(".failure", name:)
      end
      redirect_to horse_path(@horse)
    end

    def approve
      @horse = Horses::Horse.find(params[:horse_id])
      authorize @horse, :manage_bookings?, policy_class: CurrentStable::StallionPolicy

      @booking = Horses::Breeding.find(params[:id])
      authorize @booking, :approve?
      result = Horses::Stud::BookingApprover.new.approve_booking(booking: @booking, stud: @horse)
      if result.saved?
        flash[:success] = t(".success", name: @booking.mare.name)
      else
        flash[:error] = result.error
      end
      redirect_to horse_path(@horse)
    end

    def deny
      @horse = Horses::Horse.find(params[:horse_id])
      authorize @horse, :manage_bookings?, policy_class: CurrentStable::StallionPolicy

      @booking = Horses::Breeding.find(params[:id])
      authorize @booking, :deny?
      result = Horses::Stud::BookingDenier.new.decline_booking(booking: @booking, stud: @horse)
      if result.saved?
        flash[:success] = t(".success", name: @booking.mare.name)
      else
        flash[:error] = result.error
      end
      redirect_to horse_path(@horse)
    end

    def stable_dependent_fields
      @horse = Horses::Horse.includes(:manager).find(params[:horse_id])
      authorize @horse, :manage_bookings?, policy_class: CurrentStable::StallionPolicy
      slot = ::Breeding::Slot.find(params[:slot_id])
      mare_stable = Account::Stable.find(params[:stable_id])

      @booking = Horses::Breeding.new(stud: @horse, slot:, stable: mare_stable)
      broodmares = Horses::Horse::Broodmare.left_outer_joins(:next_foal).where(manager: mare_stable)
        .where("(breedings.year != ? OR breedings.id IS NULL)", Date.current.year).order(name: :asc)
      stud_slots = @booking.options_for_stud_slot_select(@horse)
      broodmares = broodmares.select do |mare|
        mare_slots = @booking.options_for_mare_slot_select(mare, stud_slots)
        mare_slots.any? { |mare_slot| mare_slot.last == slot.id }
      end
      @booking.mare = nil

      render json: broodmares.map { |mare| { id: mare.id, name: mare.name } }
    rescue ActiveRecord::RecordNotFound
      render json: []
    end

    private

    def booking_params
      params.expect(horses_breeding: [:booking_id, :slot_id, :stable_id, :mare_id, :fee])
    end
  end
end

