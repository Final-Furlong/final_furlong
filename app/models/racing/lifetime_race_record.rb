module Racing
  class LifetimeRaceRecord < ApplicationRecord
    include RaceRecordable

    self.table_name = "lifetime_race_records"
    self.primary_key = :horse_id

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :lifetime_race_record

    scope :by_horse, ->(id) { where(horse_id: id) }
    scope :winner, -> { where(wins: 1..) }
    scope :stakes_winner, -> { where(stakes_wins: 1) }
    scope :multi_stakes_winner, -> { where("stakes_wins > ?", 1) }
    scope :millionaire, -> { where(earnings: 1_000_000..1_999_999) }
    scope :multi_millionaire, -> { where(earnings: 2_000_000) }

    def self.refresh
      Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
    end

    def self.populated?
      Scenic.database.populated?(table_name)
    end

    def race_record_races_only
      record = starts.to_s
      record += "(#{stakes_starts})" if stakes_starts.positive?
      record += "-#{wins}"
      record += "(#{stakes_wins})" if stakes_wins.positive?
      record += "-#{seconds}"
      record += "(#{stakes_seconds})" if stakes_seconds.positive?
      record += "-#{thirds}"
      record += "(#{stakes_thirds})" if stakes_thirds.positive?
      record += "-#{fourths}"
      record += "(#{stakes_fourths})" if stakes_fourths.positive?
      record
    end
  end
end

# == Schema Information
#
# Table name: lifetime_race_records
# Database name: primary
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
#  horse_id       :bigint           primary key, uniquely indexed
#
# Indexes
#
#  index_lifetime_race_records_on_horse_id  (horse_id) UNIQUE
#

