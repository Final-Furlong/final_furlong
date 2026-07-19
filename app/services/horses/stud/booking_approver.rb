module Horses
  module Stud
    class BookingApprover
      attr_reader :booking, :stud, :slot, :result

      def approve_booking(booking:, stud:)
        @booking = booking
        @stud = stud
        @slot = booking.slot
        mare = booking.mare

        @result = Result.new(booking:)

        last_race_date = @stud.race_result_finishes.joins(:race).includes(:race).merge(::Racing::RaceResult.ordered_by_date(:desc)).first.race.date
        min_breed_date = last_race_date + 1.day
        if booking.date < min_breed_date
          result.error = error("horse_was_racing")
          return result
        end
        if stud.breedings.current_year.taken.where.not(id: booking.id).where(slot:).count >= Config::Breedings.mares_per_slot
          result.error = error("slot_taken")
          return result
        end

        booking.status = "approved"

        ActiveRecord::Base.transaction do
          if booking.valid? && booking.save
            if stud.manager != mare.manager
              Game::NotificationCreator.new.create_notification(
                type: ::Notifications::Breeding::Mare::BookingApprovalNotification,
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

      private

      def error(key)
        I18n.t("services.stud_booking_approver.#{key}")
      end
    end
  end
end

