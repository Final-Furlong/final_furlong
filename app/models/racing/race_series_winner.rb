module Racing
  class RaceSeriesWinner < ApplicationRecord
    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :series, class_name: "RaceSeries"

    validates :year, presence: true
    validates :year, uniqueness: { scope: :series_id }
    validates :horse_id, uniqueness: { scope: %i[series_id year] }
  end
end

# == Schema Information
#
# Table name: race_series_winners
# Database name: primary
#
#  id         :bigint           not null, primary key
#  year       :integer          default(0), not null, uniquely indexed => [series_id], indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  horse_id   :bigint           not null, indexed
#  series_id  :bigint           not null, uniquely indexed => [year]
#
# Indexes
#
#  index_race_series_winners_on_horse_id            (horse_id)
#  index_race_series_winners_on_series_id_and_year  (series_id,year) UNIQUE
#  index_race_series_winners_on_year                (year)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (series_id => race_series.id)
#

