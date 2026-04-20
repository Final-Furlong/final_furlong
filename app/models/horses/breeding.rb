module Horses
  class Breeding < ApplicationRecord
    self.ignored_columns += [:legacy_id]

    belongs_to :mare, class_name: "Horses::Horse", inverse_of: :breedings, optional: true
    belongs_to :stud, class_name: "Horses::Horse", inverse_of: :breedings
    belongs_to :stable, class_name: "Account::Stable", inverse_of: :breedings
    belongs_to :first_foal, class_name: "Horses::Horse", inverse_of: :parent_breeding_record, optional: true
    belongs_to :second_foal, class_name: "Horses::Horse", inverse_of: :twin_parent_breeding_record, optional: true

    validates :fee, :status, presence: true
    validates :mare_id, presence: true, unless: :open_booking
    validates :year, :date, presence: true, if: :approved?
    validates :due_date, presence: true, if: :bred?
    validates :status, inclusion: { in: Config::Breedings.statuses }
    validates :fee, numericality: { greater_than_or_equal_to: 0 }
    validates :due_date, comparison: { greater_than: :date }, allow_nil: true
    validates :first_foal, presence: true, if: :second_foal
    validates :open_booking, inclusion: { in: [true, false] }

    enum :status, Config::Breedings.statuses.reduce({}) { |hash, value| hash.merge({ value.to_sym => value }) }

    scope :by_year, ->(year) { where(year:) }
    scope :not_denied, -> { where.not(status: "denied") }

    def self.ransackable_attributes(_auth_object = nil)
      %w[date due_date fee mare_id status stud_id year]
    end
  end
end

# == Schema Information
#
# Table name: breedings
# Database name: primary
#
#  id                                      :bigint           not null, primary key
#  date                                    :date             indexed
#  due_date                                :date             indexed
#  fee                                     :integer          default(0), not null
#  open_booking                            :boolean          default(FALSE), not null, indexed
#  status(pending, approved, bred, denied) :enum             not null, indexed
#  year                                    :integer          default(0), not null, uniquely indexed => [mare_id, stud_id], indexed
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  first_foal_id                           :bigint           uniquely indexed
#  mare_id                                 :bigint           uniquely indexed => [stud_id, year]
#  second_foal_id                          :bigint           uniquely indexed
#  stable_id                               :bigint           not null, indexed
#  stud_id                                 :bigint           not null, uniquely indexed => [mare_id, year], indexed
#
# Indexes
#
#  index_breedings_on_date                          (date)
#  index_breedings_on_due_date                      (due_date)
#  index_breedings_on_first_foal_id                 (first_foal_id) UNIQUE
#  index_breedings_on_mare_id_and_stud_id_and_year  (mare_id,stud_id,year) UNIQUE WHERE ((open_booking IS FALSE) AND (status <> 'denied'::breeding_statuses))
#  index_breedings_on_open_booking                  (open_booking)
#  index_breedings_on_second_foal_id                (second_foal_id) UNIQUE
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
#  fk_rails_...  (stable_id => stables.id)
#  fk_rails_...  (stud_id => horses.id)
#

