module Racing
  class RaceTypeRaceRecord < ApplicationRecord
    self.table_name = "race_type_race_records"
    self.primary_key = :horse_id

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :race_type_race_record

    def self.populated?
      Scenic.database.populated?(table_name)
    end

    def readonly?
      true
    end
  end
end

# == Schema Information
#
# Table name: race_type_race_records
# Database name: primary
#
#  allowance_fourths :bigint
#  allowance_seconds :bigint
#  allowance_starts  :bigint
#  allowance_thirds  :bigint
#  allowance_wins    :bigint
#  claiming_fourths  :bigint
#  claiming_seconds  :bigint
#  claiming_starts   :bigint
#  claiming_thirds   :bigint
#  claiming_wins     :bigint
#  grade_1_fourths   :bigint
#  grade_1_seconds   :bigint
#  grade_1_starts    :bigint
#  grade_1_thirds    :bigint
#  grade_1_wins      :bigint
#  grade_2_fourths   :bigint
#  grade_2_seconds   :bigint
#  grade_2_starts    :bigint
#  grade_2_thirds    :bigint
#  grade_2_wins      :bigint
#  grade_3_fourths   :bigint
#  grade_3_seconds   :bigint
#  grade_3_starts    :bigint
#  grade_3_thirds    :bigint
#  grade_3_wins      :bigint
#  maiden_fourths    :bigint
#  maiden_seconds    :bigint
#  maiden_starts     :bigint
#  maiden_thirds     :bigint
#  maiden_wins       :bigint
#  ungraded_fourths  :bigint
#  ungraded_seconds  :bigint
#  ungraded_starts   :bigint
#  ungraded_thirds   :bigint
#  ungraded_wins     :bigint
#  horse_id          :bigint           primary key
#

