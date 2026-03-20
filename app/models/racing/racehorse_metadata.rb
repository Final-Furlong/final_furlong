module Racing
  class RacehorseMetadata < ApplicationRecord
    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :racetrack, class_name: "Racing::Racetrack"
    belongs_to :location, class_name: "Location", optional: true

    validates :rest_days_since_last_race, :workouts_since_last_race, :location_string, presence: true
    validates :energy_grade, :fitness_grade, inclusion: { in: Config::Racing.letter_grades.map(&:upcase) }
    validates :at_home, :in_transit, :currently_injured, inclusion: { in: [true, false] }

    scope :min_energy, ->(grade) { min_grade(grade, "energy_grade") }
    scope :max_energy, ->(grade) { max_grade(grade, "energy_grade") }
    scope :energy_within, ->(max, min) { grade_within(max, min, "energy_grade") }
    scope :min_fitness, ->(grade) { min_grade(grade, "fitness_grade") }
    scope :max_fitness, ->(grade) { max_grade(grade, "fitness_grade") }
    scope :fitness_within, ->(max, min) { grade_within(max, min, "fitness_grade") }
    scope :min_grade, ->(grade, key) {
      case grade.to_s.upcase
      when "A"
        where(key => grade)
      when "B"
        where(key => ["A", "B"])
      when "C"
        where(key => ["A", "B", "C"])
      when "D"
        where(key => ["A", "B", "C", "D"])
      else
        where(key => "F")
      end
    }
    scope :max_grade, ->(grade, key) {
      case grade.to_s.upcase
      when "A"
        where(key => ["A", "B", "C", "D", "F"])
      when "B"
        where(key => ["B", "C", "D", "F"])
      when "C"
        where(key => ["C", "D", "F"])
      when "D"
        where(key => ["D", "F"])
      when "F"
        where(key => "F")
      end
    }
    scope :grade_within, ->(max_grade, min_grade, key) {
      grades1 = case max_grade.to_s.upcase
      when "A"
        ["A", "B", "C", "D", "F"]
      when "B"
        ["B", "C", "D", "F"]
      when "C"
        ["C", "D", "F"]
      when "D"
        ["D", "F"]
      when "F"
        ["F"]
      end
      grades2 = case min_grade.to_s.upcase
      when "A"
        ["A"]
      when "B"
        ["A", "B"]
      when "C"
        ["A", "B", "C"]
      when "D"
        ["A", "B", "C", "D"]
      when "F"
        ["A", "B", "C", "D", "F"]
      end
      where(key => (grades1 & grades2).to_a)
    }
    scope :raced_before, ->(days) { where(last_raced_at: ..(Date.current - days.to_i.days)) }
    scope :raced_since, ->(days) { where(last_raced_at: (Date.current - days.to_i.days)..) }
    scope :shipped_before, ->(days) { where(last_shipped_at: ..(Date.current - days.to_i.days)) }
    scope :shipped_since, ->(days) { where(last_shipped_at: (Date.current - days.to_i.days)..) }
    scope :min_rest_days, ->(number) { where(rest_days_since_last_race: number.to_i..) }
    scope :max_rest_days, ->(number) { where(rest_days_since_last_race: ..number.to_i) }
    scope :min_workouts, ->(number) { where(workouts_since_last_race: number.to_i..) }
    scope :max_workouts, ->(number) { where(workouts_since_last_race: ..number.to_i) }
    scope :at_home, -> { where(at_home: true) }
    scope :not_at_home, -> { at_home.invert_where }

    def update_grades(energy:, fitness:, update_legacy: false)
      modifier_percent = (energy * 0.2).clamp(10, 20)
      modifier = rand(0...modifier_percent)
      graded_score = (rand(1...2) == 1) ? modifier : modifier * -1
      energy_score = energy * (100 - graded_score).fdiv(100)
      grade = if energy_score <= 40 then "F"
      elsif energy_score <= 70 then "D"
      elsif energy_score <= 84 then "C"
      elsif energy_score <= 94 then "B"
      else
        "A"
      end
      self.energy_grade = grade

      modifier_percent = (fitness * 0.2).clamp(10, 20)
      modifier = rand(0...modifier_percent)
      graded_score = (rand(1...2) == 1) ? modifier : modifier * -1
      fitness_score = fitness * (100 - graded_score).fdiv(100)
      grade = if fitness_score <= 40 then "F"
      elsif fitness_score <= 70 then "D"
      elsif fitness_score <= 84 then "C"
      elsif fitness_score <= 94 then "B"
      else
        "A"
      end
      self.fitness_grade = grade
      update_legacy_info if update_legacy
      if save
        [energy_grade, fitness_grade]
      else
        []
      end
    end

    def update_legacy_info
      legacy_id = horse.legacy_id
      Legacy::Horse.transaction do
        Legacy::Horse.where(ID: legacy_id).update(EnergyCurrent: energy,
          Fitness: fitness,
          DisplayEnergy: energy_grade,
          DisplayFitness: fitness_grade)
        Legacy::ViewTrainingSchedules.where(horse_id: legacy_id).update(
          energy_current: energy,
          fitness_current: fitness,
          energy_grade:,
          fitness_grade:
        )
        Legacy::ViewRacehorses.where(horse_id: legacy_id).update(energy_grade:, fitness_grade:)
      end
    end

    def distance_to_race(location)
      starting_location = at_home? ? horse.manager.racetrack.location : racetrack.location
      return 0 if starting_location == location

      Shipping::Route.with_locations(starting_location, location).pluck(:miles).uniq.first
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[at_home energy_grade fitness_grade in_transit last_raced_at last_rested_at last_shipped_at racetrack_id
        rest_days_since_last_race workouts_since_last_race location_string last_injured_at currently_injured]
    end

    def self.ransackable_associations(_auth_object = nil)
      %w[horse racetrack]
    end

    def self.ransackable_scopes(_auth_object = nil)
      %i[min_energy max_energy]
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

