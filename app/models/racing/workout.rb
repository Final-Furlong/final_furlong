module Racing
  class Workout < ApplicationRecord
    include FlagShihTzu

    ACTIVITIES = %w[walk jog canter gallop breeze].freeze

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :workouts
    belongs_to :jockey
    belongs_to :location
    belongs_to :racetrack
    belongs_to :surface, class_name: "TrackSurface"
    belongs_to :comment, class_name: "WorkoutComment"

    validates :activity1, :distance1, :condition, :date, :effort, :equipment, presence: true
    validates :activity1, :activity2, :activity3, inclusion: { in: ACTIVITIES }, allow_nil: true
    validates :condition, inclusion: { in: TrackSurface::CONDITIONS }
    validates :distance2, presence: true, if: :activity2
    validates :distance3, presence: true, if: :activity3
    validates :distance1, :distance2, :distance3, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :effort, numericality: { only_integer: true, greater_than: 0 }
    validates :confidence, numericality: { only_integer: true, greater_than: 0 }
    validates :equipment, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :time_in_seconds, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
    validates :rank, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
    validates :horse_id, uniqueness: { scope: :date }

    validates :distance1, numericality: { greater_than: Config::Workouts.walk[:min_furlongs] - 1, less_than: Config::Workouts.walk[:max_furlongs] + 1 }, if: -> { activity1 == "walk" }
    validates :distance2, numericality: { greater_than: Config::Workouts.walk[:min_furlongs] - 1, less_than: Config::Workouts.walk[:max_furlongs] + 1 }, if: -> { activity2 == "walk" }
    validates :distance3, numericality: { greater_than: Config::Workouts.walk[:min_furlongs] - 1, less_than: Config::Workouts.walk[:max_furlongs] + 1 }, if: -> { activity3 == "walk" }
    validates :distance1, numericality: { greater_than: Config::Workouts.jog[:min_furlongs] - 1, less_than: Config::Workouts.jog[:max_furlongs] + 1 }, if: -> { activity1 == "jog" }
    validates :distance2, numericality: { greater_than: Config::Workouts.jog[:min_furlongs] - 1, less_than: Config::Workouts.jog[:max_furlongs] + 1 }, if: -> { activity2 == "jog" }
    validates :distance3, numericality: { greater_than: Config::Workouts.jog[:min_furlongs] - 1, less_than: Config::Workouts.jog[:max_furlongs] + 1 }, if: -> { activity3 == "jog" }
    validates :distance1, numericality: { greater_than: Config::Workouts.canter[:min_furlongs] - 1, less_than: Config::Workouts.canter[:max_furlongs] + 1 }, if: -> { activity1 == "canter" }
    validates :distance2, numericality: { greater_than: Config::Workouts.canter[:min_furlongs] - 1, less_than: Config::Workouts.canter[:max_furlongs] + 1 }, if: -> { activity2 == "canter" }
    validates :distance3, numericality: { greater_than: Config::Workouts.canter[:min_furlongs] - 1, less_than: Config::Workouts.canter[:max_furlongs] + 1 }, if: -> { activity3 == "canter" }
    validates :distance1, numericality: { greater_than: Config::Workouts.gallop[:min_furlongs] - 1, less_than: Config::Workouts.gallop[:max_furlongs] + 1 }, if: -> { activity1 == "gallop" }
    validates :distance2, numericality: { greater_than: Config::Workouts.gallop[:min_furlongs] - 1, less_than: Config::Workouts.gallop[:max_furlongs] + 1 }, if: -> { activity2 == "gallop" }
    validates :distance3, numericality: { greater_than: Config::Workouts.gallop[:min_furlongs] - 1, less_than: Config::Workouts.gallop[:max_furlongs] + 1 }, if: -> { activity3 == "gallop" }
    validates :distance1, numericality: { greater_than: Config::Workouts.breeze[:min_furlongs] - 1, less_than: Config::Workouts.breeze[:max_furlongs] + 1 }, if: -> { activity1 == "breeze" }
    validates :distance2, numericality: { greater_than: Config::Workouts.breeze[:min_furlongs] - 1, less_than: Config::Workouts.breeze[:max_furlongs] + 1 }, if: -> { activity2 == "breeze" }
    validates :distance3, numericality: { greater_than: Config::Workouts.breeze[:min_furlongs] - 1, less_than: Config::Workouts.breeze[:max_furlongs] + 1 }, if: -> { activity3 == "breeze" }

    validate :valid_baby_distances

    def valid_baby_distances
      return if horse.age > 2

      total_distance = distance1.to_i + distance2.to_i + distance3.to_i
      if total_distance > Config::Workouts.max_distance_for_2yos
        errors.add(:base, :distance_too_long_for_2yo)
      end
      if activity1 == "gallop"
        errors.add(:distance1, :too_long, count: Config::Workouts.max_gallop_for_2yos)
      elsif activity2 == "gallop"
        errors.add(:distance2, :too_long, count: Config::Workouts.max_gallop_for_2yos)
      elsif activity3 == "gallop"
        errors.add(:distance3, :too_long, count: Config::Workouts.max_gallop_for_2yos)
      end
    end

    has_flags 1 => :blinkers,
      2 => :shadow_roll,
      3 => :wraps,
      4 => :figure_8,
      5 => :no_whip,
      :column => "equipment"
  end
end

# == Schema Information
#
# Table name: workouts
# Database name: primary
#
#  id                                           :bigint           not null, primary key
#  activity1(walk, jog, canter, gallop, breeze) :enum             not null, indexed
#  activity2(walk, jog, canter, gallop, breeze) :enum             indexed
#  activity3(walk, jog, canter, gallop, breeze) :enum             indexed
#  condition(fast, good, slow, wet)             :enum             not null, indexed
#  confidence                                   :integer          default(0), not null, indexed
#  date                                         :date             not null, indexed
#  distance1                                    :integer          default(0), not null, indexed
#  distance2                                    :integer          default(0), indexed
#  distance3                                    :integer          default(0), indexed
#  effort                                       :integer          default(0), not null, indexed
#  equipment                                    :integer          default(0), not null, indexed
#  rank                                         :integer          indexed
#  time_in_seconds                              :integer          indexed
#  created_at                                   :datetime         not null
#  updated_at                                   :datetime         not null
#  comment_id                                   :bigint           not null, indexed
#  horse_id                                     :bigint           not null, indexed
#  jockey_id                                    :bigint           not null, indexed
#  location_id                                  :bigint           not null, indexed
#  racetrack_id                                 :bigint           not null, indexed
#  surface_id                                   :bigint           not null, indexed
#
# Indexes
#
#  index_workouts_on_activity1        (activity1)
#  index_workouts_on_activity2        (activity2)
#  index_workouts_on_activity3        (activity3)
#  index_workouts_on_comment_id       (comment_id)
#  index_workouts_on_condition        (condition)
#  index_workouts_on_confidence       (confidence)
#  index_workouts_on_date             (date)
#  index_workouts_on_distance1        (distance1)
#  index_workouts_on_distance2        (distance2)
#  index_workouts_on_distance3        (distance3)
#  index_workouts_on_effort           (effort)
#  index_workouts_on_equipment        (equipment)
#  index_workouts_on_horse_id         (horse_id)
#  index_workouts_on_jockey_id        (jockey_id)
#  index_workouts_on_location_id      (location_id)
#  index_workouts_on_racetrack_id     (racetrack_id)
#  index_workouts_on_rank             (rank)
#  index_workouts_on_surface_id       (surface_id)
#  index_workouts_on_time_in_seconds  (time_in_seconds)
#
# Foreign Keys
#
#  fk_rails_...  (comment_id => workout_comments.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (jockey_id => jockeys.id)
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (racetrack_id => racetracks.id)
#  fk_rails_...  (surface_id => track_surfaces.id)
#

