module Racing
  class BreedersCupPotentialEntry < ApplicationRecord
    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :stable, class_name: "Account::Stable"
    belongs_to :race, class_name: "Racing::RaceSchedule"

    validates :record, :rank, presence: true
    validates :horse_id, uniqueness: { scope: :race_id }

    scope :ordered, -> { order(rank: :asc) }
    scope :game_owned, -> { joins(:horse).merge(Horses::Horse.game_owned) }
    scope :not_game_owned, -> { joins(:horse).merge(Horses::Horse.not_game_owned) }
  end
end

# == Schema Information
#
# Table name: breeders_cup_potential_entries
# Database name: primary
#
#  id         :bigint           not null, primary key
#  rank       :integer          default(0), not null, indexed
#  record     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  horse_id   :bigint           not null, uniquely indexed => [race_id]
#  race_id    :bigint           not null, uniquely indexed => [horse_id], indexed
#  stable_id  :bigint           not null, indexed
#
# Indexes
#
#  index_breeders_cup_potential_entries_on_horse_id_and_race_id  (horse_id,race_id) UNIQUE
#  index_breeders_cup_potential_entries_on_race_id               (race_id)
#  index_breeders_cup_potential_entries_on_rank                  (rank)
#  index_breeders_cup_potential_entries_on_stable_id             (stable_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (race_id => race_schedules.id)
#  fk_rails_...  (stable_id => stables.id)
#

