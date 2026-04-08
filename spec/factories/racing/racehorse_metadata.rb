FactoryBot.define do
  factory :racehorse_metadata, class: "Racing::RacehorseMetadata" do
    horse
    at_home { false }
    currently_injured { false }
    energy_grade { "A" }
    fitness_grade { "A" }
    in_transit { false }
    location_string { racetrack.name }
    racetrack
    location { racetrack.location }
  end
end

# == Schema Information
#
# Table name: racehorse_metadata
# Database name: primary
#
#  id                         :bigint           not null, primary key
#  at_home                    :boolean          default(TRUE), not null, indexed
#  currently_injured          :boolean          default(FALSE), not null, indexed
#  energy_grade               :string           default("F"), not null, indexed
#  fitness_grade              :string           default("F"), not null, indexed
#  in_transit                 :boolean          default(FALSE), not null, indexed
#  last_injured_at            :date             indexed
#  last_raced_at              :date             indexed
#  last_rested_at             :date             indexed
#  last_shipped_at            :date             indexed
#  latest_result_abbreviation :string
#  location_string            :string           default("Farm"), not null, indexed
#  next_entry_date            :date             indexed
#  rest_days_since_last_race  :integer          default(0), not null, indexed
#  workouts_since_last_race   :integer          default(0), not null, indexed
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  horse_id                   :bigint           not null, uniquely indexed
#  location_id                :bigint           indexed
#  racetrack_id               :bigint           not null, indexed
#
# Indexes
#
#  index_racehorse_metadata_on_at_home                    (at_home)
#  index_racehorse_metadata_on_currently_injured          (currently_injured)
#  index_racehorse_metadata_on_energy_grade               (energy_grade)
#  index_racehorse_metadata_on_fitness_grade              (fitness_grade)
#  index_racehorse_metadata_on_horse_id                   (horse_id) UNIQUE
#  index_racehorse_metadata_on_in_transit                 (in_transit)
#  index_racehorse_metadata_on_last_injured_at            (last_injured_at)
#  index_racehorse_metadata_on_last_raced_at              (last_raced_at)
#  index_racehorse_metadata_on_last_rested_at             (last_rested_at)
#  index_racehorse_metadata_on_last_shipped_at            (last_shipped_at)
#  index_racehorse_metadata_on_location_id                (location_id)
#  index_racehorse_metadata_on_location_string            (location_string)
#  index_racehorse_metadata_on_next_entry_date            (next_entry_date)
#  index_racehorse_metadata_on_racetrack_id               (racetrack_id)
#  index_racehorse_metadata_on_rest_days_since_last_race  (rest_days_since_last_race)
#  index_racehorse_metadata_on_workouts_since_last_race   (workouts_since_last_race)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (racetrack_id => racetracks.id)
#

