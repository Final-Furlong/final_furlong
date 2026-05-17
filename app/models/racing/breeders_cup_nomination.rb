module Racing
  class BreedersCupNomination < ApplicationRecord
    belongs_to :horse, class_name: "Horses::Horse"

    validates :effective_year, numericality: { only_integer: true, greater_than_or_equal_to: :horse_yob }, allow_nil: true
    validates :horse_id, uniqueness: true

    private

    def horse_yob
      return Date.current.year unless horse

      horse.date_of_birth.year
    end
  end
end

# == Schema Information
#
# Table name: breeders_cup_nominations
# Database name: primary
#
#  id             :bigint           not null, primary key
#  effective_year :integer          indexed
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  horse_id       :bigint           not null, uniquely indexed, uniquely indexed => [race_id]
#  race_id        :bigint           uniquely indexed => [horse_id], indexed
#
# Indexes
#
#  index_breeders_cup_nominations_on_effective_year        (effective_year)
#  index_breeders_cup_nominations_on_horse_id              (horse_id) UNIQUE
#  index_breeders_cup_nominations_on_horse_id_and_race_id  (horse_id,race_id) UNIQUE WHERE (race_id IS NOT NULL)
#  index_breeders_cup_nominations_on_race_id               (race_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (race_id => race_schedules.id)
#

