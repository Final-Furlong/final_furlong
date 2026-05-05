module Horses
  module Broodmare
    class BookingRequester
      attr_reader :booking, :mare, :stud, :slot, :result

      def request_booking(mare:, stud:, slot:, message: nil)
        @booking = Horses::Breeding.new(mare:, stud:, slot:)
        @stud = stud
        @mare = mare
        @slot = slot

        @result = Result.new(booking:)

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
        mare_stable = mare.manager
        booking.stable = mare_stable
        if booking.stable_id == stud.manager_id
          booking.fee = 0
        else
          options = stud.stud_options
          booking.fee = options.stud_fee
        end
        booking.status = "pending"

        ActiveRecord::Base.transaction do
          if booking.valid? && booking.save
            notification_params = {
              booking_id: booking.id,
              stud_id: stud.slug,
              stud_name: stud.name,
              mare_id: mare.slug,
              mare_name: mare.name,
              stable_name: mare.manager.name,
              slot_start_date: slot.formatted_start_day,
              slot_end_date: slot.to_s
            }
            notification_params[:message] = message if message.present?
            Game::NotificationCreator.new.create_notification(
              type: ::StudBookingRequestNotification,
              user: stud.manager.user,
              params: notification_params
            )
            result.created = true
          else
            result.created = false
            result.error = booking.errors.full_messages.to_sentence
          end
        rescue ActiveRecord::Rollback
          result.created = false
        end
        result
      end

      class Result
        attr_accessor :error, :created, :booking

        def initialize(booking:, created: false, error: nil)
          @created = created
          @booking = booking
          @error = nil
        end

        def created?
          @created
        end
      end

      private

      def error(key)
        I18n.t("services.booking_requester.#{key}")
      end
    end
  end
end

