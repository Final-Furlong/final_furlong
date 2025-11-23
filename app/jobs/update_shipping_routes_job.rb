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
    starting_location = Location.joins(:racetrack).find_by(racetracks: { name: start_track.Name })
    return unless starting_location

    end_track = Legacy::Racetrack.find(legacy_shipping.End)
    ending_location = Location.joins(:racetrack).find_by(racetracks: { name: end_track.Name })
    return unless ending_location

    route = Shipping::Route.find_or_initialize_by(starting_location:,
      ending_location:)
    route.miles = legacy_shipping.Miles
    if legacy_shipping.RDay.to_i.positive?
      route.road_days = legacy_shipping.RDay
      route.road_cost = legacy_shipping.RCost
    end
    if legacy_shipping.ADay.to_i.positive?
      route.air_days = legacy_shipping.ADay
      route.air_cost = legacy_shipping.ACost
    end
    route.save!
  end
end

