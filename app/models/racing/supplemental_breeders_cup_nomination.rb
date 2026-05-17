module Racing
  class SupplementalBreedersCupNomination < ApplicationRecord
    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :race, class_name: "Racing::RaceSchedule"

    validates :year, presence: true, comparison: { greater_than_or_equal_to: :current_year }
    validates :horse_id, uniqueness: { scope: :year }

    private

    def current_year
      Date.current.year
    end
  end
end

# == Schema Information
#
# Table name: supplemental_breeders_cup_nominations
# Database name: primary
#
#  id         :bigint           not null, primary key
#  year       :integer          default(0), not null, indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  horse_id   :bigint           not null, indexed => [race_id], uniquely indexed
#  race_id    :bigint           not null, indexed => [horse_id], indexed
#
# Indexes
#
#  idx_on_horse_id_race_id_949895b079                       (horse_id,race_id)
#  index_supplemental_breeders_cup_nominations_on_horse_id  (horse_id) UNIQUE
#  index_supplemental_breeders_cup_nominations_on_race_id   (race_id)
#  index_supplemental_breeders_cup_nominations_on_year      (year)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (race_id => race_schedules.id)
#

