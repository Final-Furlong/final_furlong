module Shipping
  class Route < ApplicationRecord
    self.table_name = "shipment_routes"

    MODES = %w[road air].freeze

    belongs_to :starting_location, class_name: "Location"
    belongs_to :ending_location, class_name: "Location"

    validates :ending_location, comparison: { other_than: :starting_location }, if: :starting_location
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

