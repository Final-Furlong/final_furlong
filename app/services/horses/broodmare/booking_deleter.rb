module Horses
  module Broodmare
    class BookingDeleter
      attr_reader :booking, :stud, :mare, :result

      def delete_booking(booking:)
        @booking = booking
        @stud = booking.stud
        @mare = booking.mare
        slot = @booking.slot

        @result = Result.new(booking:)

        ActiveRecord::Base.transaction do
          if booking.destroy!
            if stud.manager != mare.manager && stud.stud_options&.approval_required
              Game::NotificationCreator.new.create_notification(
                type: ::Notifications::Breeding::Stud::BookingRequestCancellationNotification,
                user: stud.manager.user,
                params: {
                  booking_id: booking.id,
                  stud_id: stud.slug,
                  stud_name: stud.name,
                  mare_id: mare.slug,
                  mare_name: mare.name,
                  stable_name: mare.manager.name,
                  slot_start_date: slot.formatted_start_day,
                  slot_end_date: slot.to_s
                }
              )
            end
            result.destroyed = true
          else
            result.destroyed = false
            result.error = booking.errors.full_messages.to_sentence
          end
        rescue ActiveRecord::Rollback
          result.saved = false
        end

        result.booking = booking
        result
      end

      class Result
        attr_accessor :error, :destroyed, :booking

        def initialize(booking:, destroyed: false, error: nil)
          @destroyed = destroyed
          @booking = booking
          @error = nil
        end

        def destroyed?
          @destroyed
        end
      end
    end
  end
end

