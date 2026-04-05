module Racing
  class StableAnnualRaceRecord < ApplicationRecord
    include RaceRecordable

    self.table_name = "stable_annual_race_records"
    self.primary_key = [:stable_id, :year]

    belongs_to :stable, class_name: "Account::Stable", inverse_of: :annual_race_records

    scope :ordered, -> { order(year: :asc) }
    scope :by_year, ->(year) { where(year:) }

    def self.refresh
      Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
    end

    def self.populated?
      Scenic.database.populated?(table_name)
    end

    def win_percentage
      percentage(wins, starts)
    end

    def second_percentage
      percentage(seconds, starts)
    end

    def third_percentage
      percentage(thirds, starts)
    end

    def fourth_percentage
      percentage(fourths, starts)
    end

    def otb_percentage
      percentage(wins + seconds + thirds, starts)
    end

    def percentage(numerator, denominator)
      return 0 if denominator.zero?

      (numerator.fdiv(denominator) * 100).round
    end
  end
end

# == Schema Information
#
# Table name: stable_annual_race_records
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
#  year           :integer          primary key
#  stable_id      :bigint           primary key
#

