module Racing
  class BreedersSeriesStableStanding < ApplicationRecord
    self.table_name = "breeders_series_stable_standings"
    self.primary_key = :breeder_id

    belongs_to :stable, class_name: "Account::Stable", inverse_of: :breeders_series_records

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
# Table name: breeders_series_stable_standings
# Database name: primary
#
#  earnings   :bigint
#  fifths     :integer
#  fourths    :integer
#  name       :string
#  points     :bigint
#  seconds    :integer
#  starts     :integer
#  thirds     :integer
#  wins       :integer
#  year       :integer
#  breeder_id :bigint           primary key
#

