module Racing
  class RaceRecord < ApplicationRecord
    include RaceRecordable

    self.table_name = "race_records"
    self.primary_key = [:horse_id, :year, :surface]

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :race_records

    def self.refresh
      Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: true)
    end

    def self.populated?
      Scenic.database.populated?(table_name)
    end
  end
end

# == Schema Information
#
# Table name: race_records
# Database name: primary
#
#  earnings       :bigint
#  fourths        :bigint
#  points         :bigint
#  seconds        :bigint
#  stakes_fourths :bigint
#  stakes_seconds :bigint
#  stakes_starts  :bigint
#  stakes_thirds  :bigint
#  stakes_wins    :bigint
#  starts         :bigint
#  surface        :enum             primary key, uniquely indexed => [horse_id, year]
#  thirds         :bigint
#  wins           :bigint
#  year           :float            primary key, uniquely indexed => [horse_id, surface]
#  horse_id       :bigint           primary key, uniquely indexed => [year, surface]
#
# Indexes
#
#  index_race_records_on_horse_id_and_year_and_surface  (horse_id,year,surface) UNIQUE
#

