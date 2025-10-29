module Racing
  class AnnualRaceRecord < ApplicationRecord
    include RaceRecordable

    self.table_name = "annual_race_records"
    self.primary_key = [:horse_id, :year]

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :annual_race_records

    scope :ordered, -> { order(year: :asc) }
    scope :by_year, ->(year) { where(year:) }

    def self.refresh
      Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
    end

    def self.populated?
      Scenic.database.populated?(table_name)
    end
  end
end

# == Schema Information
#
# Table name: annual_race_records
#
#  earnings       :decimal(, )
#  fourths        :bigint
#  points         :bigint
#  seconds        :bigint
#  stakes_fourths :bigint
#  stakes_seconds :bigint
#  stakes_starts  :bigint
#  stakes_thirds  :bigint
#  stakes_wins    :bigint
#  starts         :bigint
#  thirds         :bigint
#  wins           :bigint
#  year           :integer          primary key
#  horse_id       :uuid             primary key
#

