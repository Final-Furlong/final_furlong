module Shipping
  class BroodmareShipment < ApplicationRecord
    self.table_name = "broodmare_shipments"

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :starting_farm, class_name: "Account::Stable"
    belongs_to :ending_farm, class_name: "Account::Stable"

    validates :departure_date, :arrival_date, :mode, :starting_farm,
      :ending_farm, presence: true
    validates :arrival_date, comparison: { greater_than: :departure_date }, if: :departure_date
    validates :ending_farm, comparison: { other_than: :starting_farm }, if: :starting_farm
    validates :mode, inclusion: { in: Route::MODES }
  end
end

# == Schema Information
#
# Table name: broodmare_shipments
# Database name: primary
#
#  id                 :bigint           not null, primary key
#  arrival_date       :date             not null, indexed
#  departure_date     :date             not null, uniquely indexed => [horse_id]
#  mode(road, air)    :enum             indexed
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  ending_farm_id     :bigint           not null, indexed
#  horse_id           :bigint           not null, uniquely indexed => [departure_date]
#  starting_farm_id   :bigint           not null, indexed
#
# Indexes
#
#  index_broodmare_shipments_on_arrival_date                 (arrival_date)
#  index_broodmare_shipments_on_ending_farm_id               (ending_farm_id)
#  index_broodmare_shipments_on_horse_id_and_departure_date  (horse_id,departure_date) UNIQUE
#  index_broodmare_shipments_on_mode                         (mode)
#  index_broodmare_shipments_on_starting_farm_id             (starting_farm_id)
#
# Foreign Keys
#
#  fk_rails_...  (ending_farm_id => stables.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (starting_farm_id => stables.id)
#

