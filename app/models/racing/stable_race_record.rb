module Racing
  class StableRaceRecord < ApplicationRecord
    include RaceRecordable

    self.table_name = "stable_race_records"
    self.primary_key = [:stable_id, :year, :surface]

    belongs_to :stable, class_name: "Account::Stable", inverse_of: :race_records

    def self.refresh
      Scenic.database.refresh_materialized_view(table_name, concurrently: true, cascade: true)
    end

    def self.populated?
      Scenic.database.populated?(table_name)
    end
  end
end

# == Schema Information
#
# Table name: stable_race_records
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
#  surface        :enum             primary key, uniquely indexed => [stable_id, year]
#  thirds         :integer
#  wins           :integer
#  year           :integer          primary key, uniquely indexed => [stable_id, surface]
#  stable_id      :bigint           primary key, uniquely indexed => [year, surface]
#
# Indexes
#
#  index_stable_race_records_on_stable_id_and_year_and_surface  (stable_id,year,surface) UNIQUE
#

