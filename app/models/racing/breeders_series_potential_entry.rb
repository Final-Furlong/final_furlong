module Racing
  class BreedersSeriesPotentialEntry < ApplicationRecord
    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :stable, class_name: "Account::Stable"
    belongs_to :first_race, class_name: "Racing::RaceSchedule"
    belongs_to :second_race, class_name: "Racing::RaceSchedule"
    belongs_to :third_race, class_name: "Racing::RaceSchedule"

    validates :record, :rank, presence: true
    validates :horse_id, uniqueness: { scope: :first_race_id }

    scope :ordered, -> { order(rank: :asc) }
    scope :not_game_owned, -> { joins(:horse).merge(Horses::Horse.not_game_owned) }
    scope :max_rank, -> { where('rank <= ?', Config::Racing.maximum_qualified_rank) }
  end
end

# == Schema Information
#
# Table name: breeders_series_potential_entries
# Database name: primary
#
#  id             :bigint           not null, primary key
#  rank           :integer          default(0), not null, indexed
#  record         :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  first_race_id  :bigint           uniquely indexed => [horse_id], indexed
#  horse_id       :bigint           not null, uniquely indexed => [first_race_id]
#  second_race_id :bigint           indexed
#  stable_id      :bigint           not null, indexed
#  third_race_id  :bigint           indexed
#
# Indexes
#
#  idx_on_horse_id_first_race_id_ccde27d4eb                   (horse_id,first_race_id) UNIQUE
#  index_breeders_series_potential_entries_on_first_race_id   (first_race_id)
#  index_breeders_series_potential_entries_on_rank            (rank)
#  index_breeders_series_potential_entries_on_second_race_id  (second_race_id)
#  index_breeders_series_potential_entries_on_stable_id       (stable_id)
#  index_breeders_series_potential_entries_on_third_race_id   (third_race_id)
#
# Foreign Keys
#
#  fk_rails_...  (first_race_id => race_schedules.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (second_race_id => race_schedules.id)
#  fk_rails_...  (stable_id => stables.id)
#  fk_rails_...  (third_race_id => race_schedules.id)
#
