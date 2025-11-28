module Shipping
  class Route < ApplicationRecord
    self.table_name = "shipment_routes"

    belongs_to :starting_location, class_name: "Location"
    belongs_to :ending_location, class_name: "Location"

    validates :miles, presence: true
    validates :ending_location, comparison: { other_than: :starting_location }, if: :starting_location
    validates :air_cost, presence: true, if: :air_days
    validates :road_cost, presence: true, if: :road_days

    scope :with_locations, ->(starting, ending) {
      where('(starting_location_id = :starting AND ending_location_id = :ending) OR
        (starting_location_id = :ending AND ending_location_id = :starting)', { starting:, ending: })
    }
  end
end

# == Schema Information
#
# Table name: shipment_routes
# Database name: primary
#
#  id                   :bigint           not null, primary key
#  air_cost             :integer
#  air_days             :integer          indexed
#  miles                :integer          default(0), not null
#  road_cost            :integer
#  road_days            :integer          indexed
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  ending_location_id   :bigint           not null, uniquely indexed => [starting_location_id], indexed
#  starting_location_id :bigint           not null, uniquely indexed => [ending_location_id]
#
# Indexes
#
#  idx_on_starting_location_id_ending_location_id_4088f67c10  (starting_location_id,ending_location_id) UNIQUE
#  index_shipment_routes_on_air_days                          (air_days)
#  index_shipment_routes_on_ending_location_id                (ending_location_id)
#  index_shipment_routes_on_road_days                         (road_days)
#
# Foreign Keys
#
#  fk_rails_...  (ending_location_id => locations.id)
#  fk_rails_...  (starting_location_id => locations.id)
#

