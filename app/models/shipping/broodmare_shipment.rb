module Shipping
  class BroodmareShipment < ApplicationRecord
    self.table_name = "broodmare_shipments"

    MAX_DELAYED_SHIPMENT_DAYS = 60

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :starting_farm, class_name: "Account::Stable"
    belongs_to :ending_farm, class_name: "Account::Stable"

    validates :departure_date, :arrival_date, :mode, :starting_farm,
      :ending_farm, presence: true
    validates :departure_date, comparison: { greater_than_or_equal_to: -> { Date.current }, less_than_or_equal_to: :maximum_departure_date }, if: :departure_date
    validates :arrival_date, comparison: { greater_than: :departure_date }, if: :departure_date
    validates :ending_farm, comparison: { other_than: :starting_farm }, if: :starting_farm
    validates :mode, inclusion: { in: Route::MODES }

    scope :current, -> { where("departure_date <= ?", Date.current) }
    scope :future, -> { where("departure_date > ?", Date.current) }

    def future?
      departure_date > Date.current
    end

    def maximum_departure_date
      Date.current + MAX_DELAYED_SHIPMENT_DAYS.days
    end

    def options_for_destination_select
      owned_stud_ids = Account::Stable.joins(:horses).merge(Horses::Horse.stud).group(:owner_id).count

      stables = []
      stable_ids = []
      owned_stud_ids.each do |stable_id, stud_count|
        stable_ids << stable_id
        leased_studs = Horses::Horse.where(owner: stable_id).stud.where.associated(:current_lease).count
        stud_count -= leased_studs
        if stud_count.positive?
          stables << [Account::Stable.where(id: stable_id).pick(:name), stable_id]
        end
      end
      stables.sort_by! { |stable| stable.first }
      Horses::Horse.where(owner: stable_ids).stud.where.associated(:current_lease).find_each do |stud|
        manager = stud.manager
        stables << [manager.name, manager.id]
      end
      stables.sort_by { |stable| stable.first }
    end

    def options_for_mode_select
      Route::MODES.map { |mode| [I18n.t("horse.shipments.form.mode_#{mode}"), mode] }
    end
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

