module Horses::Stud
  class FutureBreedingEraser
    attr_reader :horse, :type

    def initialize(horse:, type:)
      @horse = horse
      @type = type
    end

    def run
      ActiveRecord::Base.transaction do
        Horses::Breeding.where(stud: horse).where(status: "denied").delete_all
        Horses::Breeding.where(stud: horse).where.not(status: %w[bred denied]).where(year: Date.current.year).find_each do |booking|
          notify_deleted_booking(booking:)
          booking.destroy!
        end
        Horses::Breeding.where(stud: horse, status: "bred").where("date > ?", Date.current).find_each do |future_breeding|
          future_breeding.first_foal&.destroy!
          future_breeding.second_foal&.destroy!
          future_breeding.destroy!
          notify_deleted_breeding(breeding: future_breeding)
        end
      end
    end

    private

    def notify_deleted_booking(booking:)
      mare = booking.mare
      Game::NotificationCreator.new.create_notification(
        type: "::Notifications::Horse::Stud#{type.capitalize}DeletedBookingNotification".constantize,
        user: booking.stable.user,
        params: { stud_id: horse.slug, stud_name: horse.name, mare_id: mare&.slug, mare_name: mare&.name }
      )
    end

    def notify_deleted_breeding(breeding:)
      mare = breeding.mare
      Game::NotificationCreator.new.create_notification(
        type: "::Notifications::Horse::Stud#{type.capitalize}DeletedBreedingNotification".constantize,
        user: breeding.stable.user,
        params: { stud_id: horse.slug, stud_name: horse.name, mare_id: mare&.slug, mare_name: mare&.name }
      )
    end
  end
end

