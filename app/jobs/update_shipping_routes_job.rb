class UpdateShippingRoutesJob < ApplicationJob
  queue_as :low_priority

  def perform
    Legacy::Shipping.find_each do |legacy_shipping|
      migrate_shipping_route(legacy_shipping:)
    end
  end

  private

  def migrate_shipping_route(legacy_shipping:)
    start_track = Legacy::Racetrack.find(legacy_shipping.Start)
    start_location = Location.joins(:racetrack).find_by(racetracks: { name: start_track.Name })
    return unless start_location

    end_track = Legacy::Racetrack.find(legacy_shipping.End)
    end_location = Location.joins(:racetrack).find_by(racetracks: { name: end_track.Name })
    return unless end_location

    route = Shipping::Route.find_or_initialize_by(start_location:, end_location:)
    route.miles = legacy_shipping.Miles

    route.save!
    #  ACost      :integer
    #  ADay       :integer
    #  Miles      :integer          default(0), not null
    #  RCost      :integer
    #  RDay       :integer
  end
end

