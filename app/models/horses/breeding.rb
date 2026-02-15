module Horses
  class Breeding < ApplicationRecord
    belongs_to :mare, class_name: "Horses::Horse", inverse_of: :breedings
    belongs_to :stud, class_name: "Horses::Horse", inverse_of: :breedings

    validates :fee, :status, :legacy_id, presence: true
    validates :year, :date, presence: true, if: :approved?
    validates :due_date, presence: true, if: :bred?
    validates :status, inclusion: { in: Config::Breedings.statuses }
    validates :fee, numericality: { greater_than_or_equal_to: 0 }
    validates :due_date, comparison: { greater_than: :date }, allow_nil: true

    enum :status, Config::Breedings.statuses.reduce({}) { |hash, value| hash.merge({ value.to_sym => value }) }

    scope :by_year, ->(year) { where(year:) }
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
#  status(pending, approved, bred, denied) :enum             not null, indexed
#  year                                    :integer          default(0), not null, uniquely indexed => [mare_id, stud_id], indexed
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  legacy_id                               :integer          default(0), not null, uniquely indexed
#  mare_id                                 :bigint           not null, uniquely indexed => [stud_id, year]
#  stud_id                                 :bigint           not null, uniquely indexed => [mare_id, year], indexed
#
# Indexes
#
#  index_breedings_on_date                          (date)
#  index_breedings_on_due_date                      (due_date)
#  index_breedings_on_legacy_id                     (legacy_id) UNIQUE
#  index_breedings_on_mare_id_and_stud_id_and_year  (mare_id,stud_id,year) UNIQUE WHERE (status <> 'denied'::breeding_statuses)
#  index_breedings_on_status                        (status)
#  index_breedings_on_stud_id                       (stud_id)
#  index_breedings_on_year                          (year)
#
# Foreign Keys
#
#  fk_rails_...  (mare_id => horses.id)
#  fk_rails_...  (stud_id => horses.id)
#

