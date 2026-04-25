module Horses
  module Stud
    class BookingUpdater
      attr_reader :booking, :stud, :slot, :result

      def update_booking(booking:, stud:, params:)
        @booking = booking
        @stud = stud
        @booking.stud = stud
        @slot = ::Breeding::Slot.find(params[:slot_id])

        @result = Result.new(booking:)

        booking.slot = slot
        booking.date = Date.new(Date.current.year, slot.month, slot.end_day)

        last_race_date = @stud.race_result_finishes.joins(:race).merge(::Racing::RaceResult.ordered_by_date(:desc)).first.race.date
        min_breed_date = last_race_date + 1.day
        if booking.date < min_breed_date
          result.error = error("horse_was_racing")
          return result
        end
        if stud.breedings.current_year.taken.where(slot:).count >= Config::Breedings.mares_per_slot
          result.error = error("slot_taken")
          return result
        end

        booking.year = booking.date.year
        mare_stable = Account::Stable.find(params[:stable_id])
        booking.stable = mare_stable
        booking.fee = params[:fee].to_i.clamp(0, Config::Breedings.max_stud_fee)
        if booking.stable_id == stud.manager_id
          booking.fee = 0
        end
        if params[:mare_id].blank?
          booking.open_booking = true
        else
          booking.mare = Horses::Horse.broodmare.find(params[:mare_id])
          booking.open_booking = false
        end
        booking.status = "approved"

        result.saved = booking.valid? && booking.save
        result.booking = booking
        result
      end

      class Result
        attr_accessor :error, :saved, :booking

        def initialize(booking:, saved: false, error: nil)
          @saved = saved
          @booking = booking
          @error = nil
        end

        def saved?
          @saved
        end
      end

      private

      def error(key)
        I18n.t("services.stud_booking_updater.#{key}")
      end
    end
  end
end

