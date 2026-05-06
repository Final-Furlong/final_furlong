module Horses
  module Stud
    class BookingDenier
      attr_reader :booking, :stud, :slot, :result

      def decline_booking(booking:, stud:)
        @booking = booking
        @stud = stud
        @slot = booking.slot
        mare = booking.mare

        @result = Result.new(booking:)

        booking.status = "denied"

        ActiveRecord::Base.transaction do
          if booking.valid? && booking.save
            if stud.manager != mare.manager
              Game::NotificationCreator.new.create_notification(
                type: ::MareBookingDenialNotification,
                user: mare.manager.user,
                params: {
                  booking_id: booking.id,
                  stud_id: stud.slug,
                  stud_name: stud.name,
                  mare_id: mare.slug,
                  mare_name: mare.name,
                  stable_name: stud.manager.name,
                  slot_start_date: slot.formatted_start_day,
                  slot_end_date: slot.to_s
                }
              )
            end
            result.saved = true
          else
            result.saved = false
            result.error = booking.errors.full_messages.to_sentence
          end
        rescue ActiveRecord::Rollback
          result.saved = false
        end

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
    end
  end
end

