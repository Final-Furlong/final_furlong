module Shipping
  class BroodmareShipment < ApplicationRecord
    self.table_name = "broodmare_shipments"

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :starting_farm, class_name: "Account::Stable"
    belongs_to :ending_farm, class_name: "Account::Stable"

    validates :departure_date, :arrival_date, :mode, presence: true
    validates :departure_date, comparison: { greater_than_or_equal_to: -> { Date.current }, less_than_or_equal_to: :maximum_departure_date }, on: :new_shipment
    validates :arrival_date, comparison: { greater_than: :departure_date }, if: :departure_date
    validates :ending_farm, comparison: { other_than: :starting_farm }, if: :starting_farm
    validates :mode, inclusion: { in: Config::Shipping.modes }
    validates :scheduled, inclusion: { in: [true, false] }

    scope :current, -> { where(departure_date: ..Date.current) }
    scope :future, -> { where("departure_date > ?", Date.current) }
    scope :scheduled, -> { where(scheduled: true) }

    def future?
      departure_date > Date.current
    end

    def maximum_departure_date
      Date.current + Config::Shipping.max_delay.days
    end

    def options_for_destination_select
      starting_farm ||= horse.broodmare.current_location
      owned_stud_ids = Account::Stable.joins(:horses).where.not(id: starting_farm.id).where(horses: { id: Horses::Horse.stud.where.missing(:current_lease).select(:id) }).group(:owner_id).count

      stables = []
      stable_ids = []
      owned_stud_ids.each do |stable_id, _stud_count|
        stable_ids << stable_id
        stables << [Account::Stable.where(id: stable_id).pick(:name), stable_id]
      end
      stable_ids << starting_farm.id
      Horses::Horse.stud.joins(:current_lease).where.not(current_lease: { leaser_id: stable_ids }).find_each do |stud|
        manager = stud.manager
        stables << [manager.name, manager.id]
      end
      stables.sort_by(&:first)
    end

    def options_for_mode_select
      starting_farm ||= horse.broodmare.current_location
      return [] if starting_farm.blank? || ending_farm.blank?

      modes.map do |mode|
        mode_days = route.send(:"#{mode}_days")
        days = "#{mode_days} #{I18n.t("day").pluralize(mode_days)}"
        cost = Game::MoneyFormatter.new(route.send(:"#{mode}_cost"))
        [I18n.t("horse.shipments.form.mode_#{mode}", days:, cost:), mode]
      end
    end

    def route
      starting_location = horse.broodmare.current_location.racetrack.location
      ending_location = ending_farm.racetrack.location
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
# Table name: broodmare_shipments
# Database name: primary
#
#  id                 :bigint           not null, primary key
#  arrival_date       :date             not null, indexed
#  departure_date     :date             not null, uniquely indexed => [horse_id]
#  mode(road, air)    :enum             not null, indexed
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

