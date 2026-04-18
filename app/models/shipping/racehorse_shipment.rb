module Shipping
  class RacehorseShipment < ApplicationRecord
    self.table_name = "racehorse_shipments"

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :starting_location, class_name: "Location"
    belongs_to :ending_location, class_name: "Location"

    validates :departure_date, :arrival_date, :mode, :shipping_type, presence: true
    validates :departure_date, comparison: { greater_than_or_equal_to: -> { Date.current }, less_than_or_equal_to: :maximum_departure_date }, on: :new_shipment
    validates :arrival_date, comparison: { greater_than: :departure_date }, if: :departure_date
    validates :mode, inclusion: { in: Config::Shipping.modes }, if: :mode
    validates :shipping_type, inclusion: { in: Config::Shipping.racehorse_types }
    validates :scheduled, inclusion: { in: [true, false] }

    scope :current, -> { where(departure_date: ..Date.current).where("arrival_date > ?", Date.current) }
    scope :future, -> { where("departure_date > ?", Date.current) }
    scope :not_future, -> { where(departure_date: ..Date.current) }
    scope :scheduled, -> { where(scheduled: true) }

    def future?
      departure_date > Date.current
    end

    def maximum_departure_date
      Date.current + Config::Shipping.max_delay.days
    end

    def options_for_destination_select(horse)
      location_query = Location
      list = []
      unless horse.racing.at_farm?
        list << [horse.manager.name, "Farm"]
        location_query = location_query.where.not(id: horse.race_metadata.location.id)
      end
      list += location_query.select(:id).map do |location|
        [Racing::Racetrack.where(location_id: location.id).pick(:name), location.id]
      end
      list.delete_if { |location| location.first.blank? }
      list.sort
    end

    def options_for_mode_select(max_days = 100)
      starting_location ||= horse.race_metadata.location
      return [] if starting_location.blank? || ending_location.blank?

      available_modes = modes.filter do |mode|
        mode_days = route.send(:"#{mode}_days")
        mode_days.to_i.positive? && mode_days <= max_days
      end
      available_modes.map do |mode|
        mode_days = route.send(:"#{mode}_days")
        days = "#{mode_days} #{I18n.t("day").pluralize(mode_days)}"
        cost = Game::MoneyFormatter.new(route.send(:"#{mode}_cost"))
        [I18n.t("horse.shipments.form.mode_#{mode}", days:, cost:), mode]
      end
    end

    def route
      starting_location ||= horse.race_metadata.location
      route = Shipping::Route.with_locations(starting_location, ending_location)
      route.is_a?(Shipping::Route) ? route : route.first
    end

    def modes
      route&.modes || []
    end
  end
end

# == Schema Information
#
# Table name: racehorse_shipments
# Database name: primary
#
#  id                                                          :bigint           not null, primary key
#  arrival_date                                                :date             not null, indexed
#  departure_date                                              :date             not null, uniquely indexed => [horse_id]
#  mode(road, air)                                             :enum             not null, indexed
#  scheduled                                                   :boolean          default(FALSE), not null, indexed
#  shipping_type(track_to_track, farm_to_track, track_to_farm) :enum             not null, indexed
#  created_at                                                  :datetime         not null
#  updated_at                                                  :datetime         not null
#  ending_location_id                                          :bigint           not null, indexed
#  horse_id                                                    :bigint           not null, uniquely indexed => [departure_date]
#  starting_location_id                                        :bigint           not null, indexed
#
# Indexes
#
#  index_racehorse_shipments_on_arrival_date                 (arrival_date)
#  index_racehorse_shipments_on_ending_location_id           (ending_location_id)
#  index_racehorse_shipments_on_horse_id_and_departure_date  (horse_id,departure_date) UNIQUE
#  index_racehorse_shipments_on_mode                         (mode)
#  index_racehorse_shipments_on_scheduled                    (scheduled)
#  index_racehorse_shipments_on_shipping_type                (shipping_type)
#  index_racehorse_shipments_on_starting_location_id         (starting_location_id)
#
# Foreign Keys
#
#  fk_rails_...  (ending_location_id => locations.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (starting_location_id => locations.id)
#

