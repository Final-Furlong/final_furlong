module Racing
  class RaceRecord < ApplicationRecord
    self.table_name = "race_records"
    self.ignored_columns += ["old_id", "old_horse_id"]

    TYPES = %w[dirt turf steeplechase].freeze

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :race_records

    validates :year, :starts, :stakes_starts, :wins, :stakes_wins, :seconds, :stakes_seconds,
      :thirds, :stakes_thirds, :fourths, :stakes_fourths, :points, :earnings, presence: true
    validates :starts, :stakes_starts, :wins, :stakes_wins, :seconds, :stakes_seconds,
      :thirds, :stakes_thirds, :fourths, :stakes_fourths,
      numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :year, numericality: { only_integer: true },
      comparison: { greater_than_or_equal_to: 1996, less_than_or_equal_to: -> { Date.current.year } }
    validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :result_type, inclusion: { in: TYPES }, uniqueness: { scope: [:horse_id, :year] }
  end
end

# == Schema Information
#
# Table name: race_records
#
#  id                                    :bigint           not null, primary key
#  earnings                              :bigint           default(0), not null
#  fourths                               :integer          default(0), not null
#  points                                :integer          default(0), not null
#  result_type(dirt, turf, steeplechase) :enum             default("dirt"), uniquely indexed => [horse_id, year], indexed
#  seconds                               :integer          default(0), not null
#  stakes_fourths                        :integer          default(0), not null
#  stakes_seconds                        :integer          default(0), not null
#  stakes_starts                         :integer          default(0), not null, indexed
#  stakes_thirds                         :integer          default(0), not null
#  stakes_wins                           :integer          default(0), not null, indexed
#  starts                                :integer          default(0), not null, indexed
#  thirds                                :integer          default(0), not null
#  wins                                  :integer          default(0), not null, indexed
#  year                                  :integer          default(1996), not null, uniquely indexed => [horse_id, result_type], indexed
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  horse_id                              :integer          not null, uniquely indexed => [year, result_type]
#
# Indexes
#
#  index_race_records_on_horse_id_and_year_and_result_type  (horse_id,year,result_type) UNIQUE
#  index_race_records_on_result_type                        (result_type)
#  index_race_records_on_stakes_starts                      (stakes_starts)
#  index_race_records_on_stakes_wins                        (stakes_wins)
#  index_race_records_on_starts                             (starts)
#  index_race_records_on_wins                               (wins)
#  index_race_records_on_year                               (year)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id) ON DELETE => cascade ON UPDATE => cascade
#

