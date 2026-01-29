module Shipping
  class RacehorseShipment < ApplicationRecord
    self.table_name = "racehorse_shipments"

    SHIPPING_TYPES = %w[track_to_track track_to_farm farm_to_track].freeze
    MAX_DELAYED_SHIPMENT_DAYS = 60

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :starting_location, class_name: "Location"
    belongs_to :ending_location, class_name: "Location"

    validates :departure_date, :arrival_date, :mode, :shipping_type, presence: true
    validates :departure_date, comparison: { greater_than_or_equal_to: -> { Date.current }, less_than_or_equal_to: :maximum_departure_date }, on: :new_shipment
    validates :arrival_date, comparison: { greater_than: :departure_date }, if: :departure_date
    validates :mode, inclusion: { in: Route::MODES }, if: :mode
    validates :shipping_type, inclusion: { in: SHIPPING_TYPES }

    scope :current, -> { where(departure_date: ..Date.current).where("arrival_date > ?", Date.current) }
    scope :future, -> { where("departure_date > ?", Date.current) }

    def future?
      departure_date > Date.current
    end

    def maximum_departure_date
      Date.current + MAX_DELAYED_SHIPMENT_DAYS.days
    end

    def options_for_destination_select(horse)
      location_query = Location
      list = []
      unless horse.racing.at_farm?
        list << [horse.manager.name, "Farm"]
        location_query = location_query.where.not(id: horse.racing.current_location.id)
      end
      list += location_query.select(:id).map do |location|
        [Racing::Racetrack.where(location_id: location.id).pick(:name), location.id]
      end
      list.delete_if { |location| location.first.blank? }
      list.sort
    end

    def options_for_mode_select
      Route::MODES.map { |mode| [I18n.t("horse.shipments.form.mode_#{mode}"), mode] }
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
#  index_racehorse_shipments_on_shipping_type                (shipping_type)
#  index_racehorse_shipments_on_starting_location_id         (starting_location_id)
#
# Foreign Keys
#
#  fk_rails_...  (ending_location_id => locations.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (starting_location_id => locations.id)
#

