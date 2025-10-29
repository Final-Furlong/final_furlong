module Racing
  class LifetimeRaceRecord < ApplicationRecord
    include RaceRecordable

    self.table_name = "lifetime_race_records"
    self.primary_key = :horse_id

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :lifetime_race_record

    scope :by_horse, ->(id) { where(horse_id: id) }

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
# Table name: lifetime_race_records
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
#  horse_id       :uuid             primary key, uniquely indexed
#
# Indexes
#
#  index_lifetime_race_records_on_horse_id  (horse_id) UNIQUE
#

