module Racing
  class RaceStats < ApplicationRecord
    self.table_name = "racehorse_stats"

    self.ignored_columns += %i[energy fitness desired_equipment energy_regain_rate hasbeen_at mature_at natural_energy natural_energy_loss_rate natural_energy_regain_rate]

    GRADES = %w[A B C D F].freeze

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :racetrack, class_name: "Racing::Racetrack"

    validates :rest_days_since_last_race, :workouts_since_last_race, presence: true
    validates :energy_grade, :fitness_grade, inclusion: { in: GRADES }
    validates :at_home, :in_transit, inclusion: { in: [true, false] }

    def update_grades
      modifier_percent = (energy * 0.2).clamp(10, 20)
      modifier = rand(0...modifier_percent)
      graded_score = (rand(1...2) == 1) ? modifier : modifier * -1
      energy_score = energy * graded_score
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
      fitness_score = fitness * graded_score
      grade = if fitness_score <= 40 then "F"
      elsif fitness_score <= 70 then "D"
      elsif fitness_score <= 84 then "C"
      elsif fitness_score <= 94 then "B"
      else
        "A"
      end
      self.fitness_grade = grade
      save
    end
  end
end

# == Schema Information
#
# Table name: racehorse_stats
# Database name: primary
#
#  id                        :bigint           not null, primary key
#  at_home                   :boolean          default(TRUE), not null, indexed
#  energy_grade              :string           default("F"), not null, indexed
#  fitness_grade             :string           default("F"), not null, indexed
#  in_transit                :boolean          default(FALSE), not null, indexed
#  last_raced_at             :date             indexed
#  last_rested_at            :date             indexed
#  last_shipped_at           :date             indexed
#  rest_days_since_last_race :integer          default(0), not null, indexed
#  workouts_since_last_race  :integer          default(0), not null, indexed
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  horse_id                  :bigint           not null, uniquely indexed
#  racetrack_id              :bigint           not null, indexed
#
# Indexes
#
#  index_racehorse_stats_on_at_home                     (at_home)
#  index_racehorse_stats_on_desired_equipment           (desired_equipment)
#  index_racehorse_stats_on_energy                      (energy)
#  index_racehorse_stats_on_energy_grade                (energy_grade)
#  index_racehorse_stats_on_energy_regain_rate          (energy_regain_rate)
#  index_racehorse_stats_on_fitness                     (fitness)
#  index_racehorse_stats_on_fitness_grade               (fitness_grade)
#  index_racehorse_stats_on_horse_id                    (horse_id) UNIQUE
#  index_racehorse_stats_on_in_transit                  (in_transit)
#  index_racehorse_stats_on_last_raced_at               (last_raced_at)
#  index_racehorse_stats_on_last_rested_at              (last_rested_at)
#  index_racehorse_stats_on_last_shipped_at             (last_shipped_at)
#  index_racehorse_stats_on_natural_energy              (natural_energy)
#  index_racehorse_stats_on_natural_energy_loss_rate    (natural_energy_loss_rate)
#  index_racehorse_stats_on_natural_energy_regain_rate  (natural_energy_regain_rate)
#  index_racehorse_stats_on_racetrack_id                (racetrack_id)
#  index_racehorse_stats_on_rest_days_since_last_race   (rest_days_since_last_race)
#  index_racehorse_stats_on_workouts_since_last_race    (workouts_since_last_race)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (racetrack_id => racetracks.id)
#

