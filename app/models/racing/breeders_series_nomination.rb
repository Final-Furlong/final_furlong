module Racing
  class BreedersSeriesNomination < ApplicationRecord
    belongs_to :stable, class_name: "Account::Stable"

    validates :year, presence: true
  end
end

# == Schema Information
#
# Table name: breeders_series_nominations
# Database name: primary
#
#  id                                                                                                                                                                                         :bigint           not null, primary key
#  series_type(2yo_dirt,2yo_filly_dirt,2yo_turf,2yo_filly_turf,3yo_dirt,3yo_filly_dirt,3yo_turf,3yo_filly_turf,4yo_dirt,4yo_mare_dirt,4yo_turf,4yo_mare_turf,steeplechase,steeplechase_filly) :enum             uniquely indexed => [stable_id, year], indexed
#  year                                                                                                                                                                                       :integer          default(0), not null, uniquely indexed => [stable_id, series_type], indexed
#  created_at                                                                                                                                                                                 :datetime         not null
#  updated_at                                                                                                                                                                                 :datetime         not null
#  stable_id                                                                                                                                                                                  :bigint           not null, uniquely indexed => [series_type, year]
#
# Indexes
#
#  idx_on_stable_id_series_type_year_8e8c9eec73      (stable_id,series_type,year) UNIQUE
#  index_breeders_series_nominations_on_series_type  (series_type)
#  index_breeders_series_nominations_on_year         (year)
#
# Foreign Keys
#
#  fk_rails_...  (stable_id => stables.id)
#

