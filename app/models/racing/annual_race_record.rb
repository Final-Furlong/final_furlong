module Racing
  class AnnualRaceRecord < ApplicationRecord
    include RaceRecordable

    self.table_name = "annual_race_records"
    self.primary_key = [:horse_id, :year]

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :annual_race_records

    scope :ordered, -> { order(year: :asc) }
    scope :by_year, ->(year) { where(year:) }

    def self.refresh
      Scenic.database.refresh_materialized_view(table_name, concurrently: true, cascade: false)
    end

    def self.populated?
      Scenic.database.populated?(table_name)
    end
  end
end

# == Schema Information
#
# Table name: annual_race_records
# Database name: primary
#
#  earnings       :bigint
#  fourths        :integer
#  points         :bigint
#  seconds        :integer
#  stakes_fourths :integer
#  stakes_seconds :integer
#  stakes_starts  :integer
#  stakes_thirds  :integer
#  stakes_wins    :integer
#  starts         :integer
#  thirds         :integer
#  wins           :integer
#  year           :integer          primary key, uniquely indexed => [horse_id]
#  horse_id       :bigint           primary key, uniquely indexed => [year]
#
# Indexes
#
#  index_annual_race_records_on_horse_id_and_year  (horse_id,year) UNIQUE
#

