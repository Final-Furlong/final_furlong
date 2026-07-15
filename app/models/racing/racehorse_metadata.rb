module Racing
  class RacehorseMetadata < ApplicationRecord
    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :racetrack, class_name: "Racing::Racetrack"
    belongs_to :location, class_name: "Location", optional: true

    validates :rest_days_since_last_race, :workouts_since_last_race, :location_string, presence: true
    validates :energy_grade, :fitness_grade, inclusion: { in: Config::Racing.letter_grades.map(&:upcase) }
    validates :at_home, :in_transit, :currently_injured, inclusion: { in: [true, false] }

    scope :shippable_to_location, ->(id, cost, days) {
      # n.b. DISTINCT UNNEST(ARRAY[]) is postgres-specific syntax
      where("racehorse_metadata.location_id = :id OR (racehorse_metadata.in_transit = FALSE AND racehorse_metadata.location_id IN
        (SELECT DISTINCT UNNEST(ARRAY[starting_location_id, ending_location_id]) FROM shipment_routes
        WHERE ((starting_location_id = racehorse_metadata.location_id AND ending_location_id = :id) OR
          (starting_location_id = :id AND ending_location_id = racehorse_metadata.location_id))
          AND ((road_days IS NOT NULL AND road_days <= :days AND road_cost <= :cost) OR
            (air_days IS NOT NULL AND air_days <= :days AND air_cost <= :cost))))",
        { id:, cost:, days: })
    }

    def update_grades(energy:, fitness:)
      modifier = rand(1..10)
      graded_score = (rand(1...2) == 1) ? modifier : modifier * -1
      energy_score = energy * (100 - graded_score).fdiv(100)
      grade = if energy_score <= 40 then "F"
      elsif energy_score <= 60 then "D"
      elsif energy_score <= 75 then "C"
      elsif energy_score <= 90 then "B"
      else
        "A"
      end
      self.energy_grade = grade

      modifier = rand(1..10)
      graded_score = (rand(1...2) == 1) ? modifier : modifier * -1
      fitness_score = fitness * (100 - graded_score).fdiv(100)
      grade = if fitness_score <= 40 then "F"
      elsif fitness_score <= 60 then "D"
      elsif fitness_score <= 75 then "C"
      elsif fitness_score <= 90 then "B"
      else
        "A"
      end
      self.fitness_grade = grade
      if save
        [energy_grade, fitness_grade]
      else
        []
      end
    end

    def distance_to_race(location)
      starting_location = at_home? ? horse.manager.racetrack.location : racetrack.location
      return 0 if starting_location == location

      Shipping::Route.with_locations(starting_location, location).pluck(:miles).uniq.first
    end

    def grade_at_least?(grade, key)
      value = send(key.to_sym).to_s.upcase
      case grade.to_s.upcase
      when "A"
        value == grade
      when "B"
        ["A", "B"].include?(value)
      when "C"
        ["A", "B", "C"].include?(value)
      when "D"
        ["A", "B", "C", "D"].include?(value)
      else
        true
      end
    end

    def self.min_grade_levels(grade)
      case grade.to_s.upcase
      when "A"
        [grade.to_s.upcase]
      when "B"
        %w[A B]
      when "C"
        %w[A B C]
      when "D"
        %w[A B C D]
      else
        %w[A B C D F]
      end
    end

    def self.max_grade_levels(grade)
      case grade.to_s.upcase
      when "A"
        %w[A B C D F]
      when "B"
        %w[B C D F]
      when "C"
        %w[C D F]
      when "D"
        %w[D F]
      when "F"
        %w[F]
      end
    end

    def self.grade_levels_range(min_grade, max_grade)
      grades1 = max_grade_levels(max_grade)
      grades2 = min_grade_levels(min_grade)
      (grades1 & grades2).to_a
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[at_home energy_grade fitness_grade in_transit last_raced_at last_rested_at last_shipped_at racetrack_id
        rest_days_since_last_race workouts_since_last_race location_string last_injured_at currently_injured]
    end

    def self.ransackable_associations(_auth_object = nil)
      %w[horse racetrack]
    end

    def self.ransackable_scopes(_auth_object = nil)
      %i[]
    end
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

