module Horses
  class Breeding < ApplicationRecord
    self.ignored_columns += [:legacy_id]

    belongs_to :slot, class_name: "Breeding::Slot", inverse_of: :breedings, optional: true
    belongs_to :mare, class_name: "Horses::Horse", inverse_of: :next_foal, optional: true
    belongs_to :stud, class_name: "Horses::Horse", inverse_of: :breedings
    belongs_to :stable, class_name: "Account::Stable", inverse_of: :breedings
    belongs_to :first_foal, class_name: "Horses::Horse", inverse_of: :parent_breeding_record, optional: true
    belongs_to :second_foal, class_name: "Horses::Horse", inverse_of: :twin_parent_breeding_record, optional: true

    validates :fee, :status, presence: true
    validates :mare_id, presence: true, unless: :open_booking
    validates :year, :date, presence: true, if: :approved?
    validates :year, :date, :due_date, presence: true, if: :bred?
    validates :status, inclusion: { in: Config::Breedings.statuses }
    validates :fee, numericality: { greater_than_or_equal_to: 0 }
    validates :due_date, comparison: { greater_than: :date }, allow_nil: true
    validates :mare_id, comparison: { other_than: :stud_id }, allow_nil: true
    validates :first_foal, presence: true, if: :second_foal
    validates :open_booking, inclusion: { in: [true, false] }

    enum :status, Config::Breedings.statuses.reduce({}) { |hash, value| hash.merge({ value.to_sym => value }) }

    scope :current_year, -> { by_year(Date.current.year) }
    scope :by_year, ->(year) { where(year:) }
    scope :not_denied, -> { where.not(status: "denied") }
    scope :taken, -> { where(status: %w[approved bred]) }
    scope :not_missed, -> { joins(:slot).merge(::Breeding::Slot.not_missed) }
    scope :missed, -> { joins(:slot).merge(::Breeding::Slot.missed) }
    scope :ordered_by_status, -> { in_order_of(:status, %w[bred approved pending denied]) }
    scope :available_for_mare, ->(mare) { where("(mare_id = ? OR (mare_id IS NULL AND open_booking = TRUE AND stable_id = ?))", mare.id, mare.manager_id) }

    def self.ransackable_attributes(_auth_object = nil)
      %w[date due_date fee mare_id status stud_id year]
    end

    def pick_event
      return event unless event.nil?

      if rand(1..2000) == 1
        (rand(1..2) == 1) ? "twins_alive" : "twins_death"
      elsif rand(1..500) == 1
        "stillborn"
      elsif rand(1..750) == 1
        "death"
      else
        "birth"
      end
    end

    def pick_due_date
      date + rand(335..345).days
    end

    def missed?
      return true if slot.month < date.month

      date.day < slot.end_day
    end

    def options_for_stable_select
      list = [[stud.manager.name, stud.manager.id]]
      Account::Stable.where.not(id: stud.manager_id).active.joins(:horses).where(horses: Horses::Horse.broodmare).distinct.order(name: :asc).each do |stable|
        list << [stable.name, stable.id]
      end
      list
    end

    def max_due_date
      nil

      # TODO: implement this query for broodmares
      # this_slot = Config::Breedings.slots.find_index { |s| s[:month] == slot.month && s[:end] == slot.end_day }
      # return unless (Config::Breedings.slots.count - this_slot) > 5

      # max_slot = Config::Breedings.slots[this_slot + 5]
      # Date.new(Date.current.year, max_slot[:month], max_slot[:end])
    end
  end
end

# == Schema Information
#
# Table name: breedings
# Database name: primary
#
#  id                                                       :bigint           not null, primary key
#  date                                                     :date             indexed
#  due_date                                                 :date             indexed
#  event(twins_alive, twins_death, stillborn, death, birth) :enum             indexed
#  fee                                                      :integer          default(0), not null
#  open_booking                                             :boolean          default(FALSE), not null, indexed
#  status(pending, approved, bred, denied)                  :enum             not null, indexed
#  year                                                     :integer          default(0), not null, uniquely indexed => [mare_id, stud_id], indexed
#  created_at                                               :datetime         not null
#  updated_at                                               :datetime         not null
#  first_foal_id                                            :bigint           uniquely indexed
#  mare_id                                                  :bigint           uniquely indexed => [stud_id, year]
#  second_foal_id                                           :bigint           uniquely indexed
#  slot_id                                                  :bigint           indexed
#  stable_id                                                :bigint           not null, indexed
#  stud_id                                                  :bigint           not null, uniquely indexed => [mare_id, year], indexed
#
# Indexes
#
#  index_breedings_on_date                          (date)
#  index_breedings_on_due_date                      (due_date)
#  index_breedings_on_event                         (event)
#  index_breedings_on_first_foal_id                 (first_foal_id) UNIQUE
#  index_breedings_on_mare_id_and_stud_id_and_year  (mare_id,stud_id,year) UNIQUE WHERE ((open_booking IS FALSE) AND (status <> 'denied'::breeding_statuses))
#  index_breedings_on_open_booking                  (open_booking)
#  index_breedings_on_second_foal_id                (second_foal_id) UNIQUE
#  index_breedings_on_slot_id                       (slot_id)
#  index_breedings_on_stable_id                     (stable_id)
#  index_breedings_on_status                        (status)
#  index_breedings_on_stud_id                       (stud_id)
#  index_breedings_on_year                          (year)
#
# Foreign Keys
#
#  fk_rails_...  (first_foal_id => horses.id)
#  fk_rails_...  (mare_id => horses.id)
#  fk_rails_...  (second_foal_id => horses.id)
#  fk_rails_...  (slot_id => breeding_slots.id)
#  fk_rails_...  (stable_id => stables.id)
#  fk_rails_...  (stud_id => horses.id)
#

