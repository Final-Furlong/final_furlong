module Racing
  class Workout < ApplicationRecord
    include Equipmentable

    self.table_name = "workouts"
    self.ignored_columns += ["rank"]

    attr_accessor :special_event, :special_event_time, :confidence,
      :energy_loss, :fitness_gain

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :jockey
    belongs_to :location
    belongs_to :racetrack
    belongs_to :surface, class_name: "TrackSurface"
    belongs_to :comment, class_name: "Racing::WorkoutComment", optional: true, inverse_of: :workouts

    validates :activity1, :distance1, :condition, :date, :effort, :equipment, presence: true
    validates :confidence, :comment, presence: true, on: :complete_workout
    validates :activity1, :activity2, :activity3, inclusion: { in: Config::Workouts.activities.map(&:downcase) }, allow_nil: true
    validates :condition, inclusion: { in: Config::Racing.conditions.map(&:downcase) }
    validates :distance2, presence: true, if: :activity2
    # validates :activity2_time_in_seconds, presence: true, if: :activity2
    validates :distance3, presence: true, if: :activity3
    # validates :activity3_time_in_seconds, presence: true, if: :activity3
    validates :distance1, :distance2, :distance3, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :effort, numericality: { only_integer: true, greater_than: 0 }
    validates :confidence, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, on: :complete_workout
    validates :equipment, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :activity1_time_in_seconds, numericality: { only_integer: true, greater_than: 0 }, on: :complete_workout, allow_nil: true
    validates :activity2_time_in_seconds, numericality: { only_integer: true, greater_than: 0 }, on: :complete_workout, allow_nil: true
    validates :activity3_time_in_seconds, numericality: { only_integer: true, greater_than: 0 }, on: :complete_workout, allow_nil: true
    validates :time_in_seconds, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true, on: :complete_workout
    validates :horse_id, uniqueness: { scope: :date }

    validates :distance1, numericality: { greater_than: Config::Workouts.dig(:walk, :min_furlongs) - 1, less_than: Config::Workouts.dig(:walk, :max_furlongs) + 1 }, if: -> { activity1 == "walk" }
    validates :distance2, numericality: { greater_than: Config::Workouts.dig(:walk, :min_furlongs) - 1, less_than: Config::Workouts.dig(:walk, :max_furlongs) + 1 }, if: -> { activity2 == "walk" }
    validates :distance3, numericality: { greater_than: Config::Workouts.dig(:walk, :min_furlongs) - 1, less_than: Config::Workouts.dig(:walk, :max_furlongs) + 1 }, if: -> { activity3 == "walk" }
    validates :distance1, numericality: { greater_than: Config::Workouts.dig(:jog, :min_furlongs) - 1, less_than: Config::Workouts.dig(:jog, :max_furlongs) + 1 }, if: -> { activity1 == "jog" }
    validates :distance2, numericality: { greater_than: Config::Workouts.dig(:jog, :min_furlongs) - 1, less_than: Config::Workouts.dig(:jog, :max_furlongs) + 1 }, if: -> { activity2 == "jog" }
    validates :distance3, numericality: { greater_than: Config::Workouts.dig(:jog, :min_furlongs) - 1, less_than: Config::Workouts.dig(:jog, :max_furlongs) + 1 }, if: -> { activity3 == "jog" }
    validates :distance1, numericality: { greater_than: Config::Workouts.dig(:canter, :min_furlongs) - 1, less_than: Config::Workouts.dig(:canter, :max_furlongs) + 1 }, if: -> { activity1 == "canter" }
    validates :distance2, numericality: { greater_than: Config::Workouts.dig(:canter, :min_furlongs) - 1, less_than: Config::Workouts.dig(:canter, :max_furlongs) + 1 }, if: -> { activity2 == "canter" }
    validates :distance3, numericality: { greater_than: Config::Workouts.dig(:canter, :min_furlongs) - 1, less_than: Config::Workouts.dig(:canter, :max_furlongs) + 1 }, if: -> { activity3 == "canter" }
    validates :distance1, numericality: { greater_than: Config::Workouts.dig(:gallop, :min_furlongs) - 1, less_than: Config::Workouts.dig(:gallop, :max_furlongs) + 1 }, if: -> { activity1 == "gallop" }
    validates :distance2, numericality: { greater_than: Config::Workouts.dig(:gallop, :min_furlongs) - 1, less_than: Config::Workouts.dig(:gallop, :max_furlongs) + 1 }, if: -> { activity2 == "gallop" }
    validates :distance3, numericality: { greater_than: Config::Workouts.dig(:gallop, :min_furlongs) - 1, less_than: Config::Workouts.dig(:gallop, :max_furlongs) + 1 }, if: -> { activity3 == "gallop" }
    validates :distance1, numericality: { greater_than: Config::Workouts.dig(:breeze, :min_furlongs) - 1, less_than: Config::Workouts.dig(:breeze, :max_furlongs) + 1 }, if: -> { activity1 == "breeze" }
    validates :distance2, numericality: { greater_than: Config::Workouts.dig(:breeze, :min_furlongs) - 1, less_than: Config::Workouts.dig(:breeze, :max_furlongs) + 1 }, if: -> { activity2 == "breeze" }
    validates :distance3, numericality: { greater_than: Config::Workouts.dig(:breeze, :min_furlongs) - 1, less_than: Config::Workouts.dig(:breeze, :max_furlongs) + 1 }, if: -> { activity3 == "breeze" }

    validate :valid_baby_distances

    def options_for_effort_select
      levels = Config::Workouts.effort_levels.sort.reverse
      levels.map do |level|
        [I18n.t("horse.workouts.form.effort_#{level}"), level]
      end
    end

    def options_for_surface_select
      options = horse.race_options
      surfaces = if options.racehorse_type == "jump"
        ["steeplechase"]
      else
        surface_list = []
        surface_list << "dirt" if options.trains_on_dirt
        surface_list << "turf" if options.trains_on_turf
        surface_list
      end
      surfaces.map do |surface|
        [I18n.t("horse.workouts.form.surface_#{surface}"), surface]
      end
    end

    def store_initial_options(schedule)
      activities = schedule.daily_activities
      self.activity1 = activities.activity1
      self.activity2 = activities.activity2
      self.activity3 = activities.activity3
      self.distance1 = activities.distance1
      self.distance2 = activities.distance2
      self.distance3 = activities.distance3
      self.effort = 100
      options = horse.race_options
      self.jockey = options&.first_jockey
      self.racetrack = horse.race_metadata.racetrack
      if racetrack && options.racehorse_type == "jump"
        self.surface = racetrack.surfaces.steeplechase.first
      elsif racetrack && options.racehorse_type != "jump"
        if options.trains_on_dirt && !options.trains_on_turf
          self.surface = racetrack.surfaces.dirt.first
        elsif options.trains_on_turf && !options.trains_on_dirt
          self.surface = racetrack.surfaces.turf.first
        end
      end
    end

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

    def activity_string(key)
      activity = send(:"activity#{key}")
      return I18n.t("common.dash") if activity.blank?

      distance = send(:"distance#{key}")
      distance_i18n = I18n.t("common.distances.#{distance}_furlongs")
      "#{activity.capitalize} (#{distance_i18n})"
    end

    def activity_time(key)
      method = (key == :total) ? "total_time_in_seconds" : "activity#{key}_time_in_seconds"
      time = send(:"#{method}")
      return if time.to_i.zero?

      time_string(time)
    end

    def time_string(seconds)
      minutes = (seconds / 60).floor
      seconds = (seconds % 60).floor
      [minutes, "%02d" % seconds].join(":")
    end

    def activity_count
      if activity3
        3
      elsif activity2
        2
      else
        1
      end
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[activity1 activity2 activity3 comment_id condition confidence date distance1
        distance2 distance3 effort equipment horse_id jockey_id time_in_seconds]
    end
  end
end

# == Schema Information
#
# Table name: workouts
# Database name: primary
#
#  id                                           :bigint           not null, primary key
#  activity1(walk, jog, canter, gallop, breeze) :enum             not null, indexed
#  activity1_time_in_seconds                    :integer          default(0), indexed
#  activity2(walk, jog, canter, gallop, breeze) :enum             indexed
#  activity2_time_in_seconds                    :integer          default(0), indexed
#  activity3(walk, jog, canter, gallop, breeze) :enum             indexed
#  activity3_time_in_seconds                    :integer          default(0), indexed
#  condition(fast, good, slow, wet)             :enum             not null, indexed
#  confidence                                   :integer          default(0), not null, indexed
#  date                                         :date             not null, indexed, uniquely indexed => [horse_id]
#  distance1                                    :integer          default(0), not null, indexed
#  distance2                                    :integer          default(0), indexed
#  distance3                                    :integer          default(0), indexed
#  effort                                       :integer          default(0), not null, indexed
#  equipment                                    :integer          default(0), not null, indexed
#  time_in_seconds                              :integer          indexed
#  total_time_in_seconds                        :integer          default(0), indexed
#  created_at                                   :datetime         not null
#  updated_at                                   :datetime         not null
#  comment_id                                   :bigint           not null, indexed
#  horse_id                                     :bigint           not null, uniquely indexed => [date]
#  jockey_id                                    :bigint           not null, indexed
#  location_id                                  :bigint           not null, indexed
#  racetrack_id                                 :bigint           not null, indexed
#  surface_id                                   :bigint           not null, indexed
#
# Indexes
#
#  index_workouts_on_activity1                  (activity1)
#  index_workouts_on_activity1_time_in_seconds  (activity1_time_in_seconds)
#  index_workouts_on_activity2                  (activity2)
#  index_workouts_on_activity2_time_in_seconds  (activity2_time_in_seconds)
#  index_workouts_on_activity3                  (activity3)
#  index_workouts_on_activity3_time_in_seconds  (activity3_time_in_seconds)
#  index_workouts_on_comment_id                 (comment_id)
#  index_workouts_on_condition                  (condition)
#  index_workouts_on_confidence                 (confidence)
#  index_workouts_on_date                       (date)
#  index_workouts_on_distance1                  (distance1)
#  index_workouts_on_distance2                  (distance2)
#  index_workouts_on_distance3                  (distance3)
#  index_workouts_on_effort                     (effort)
#  index_workouts_on_equipment                  (equipment)
#  index_workouts_on_horse_id_and_date          (horse_id,date) UNIQUE
#  index_workouts_on_jockey_id                  (jockey_id)
#  index_workouts_on_location_id                (location_id)
#  index_workouts_on_racetrack_id               (racetrack_id)
#  index_workouts_on_rank                       (rank)
#  index_workouts_on_surface_id                 (surface_id)
#  index_workouts_on_time_in_seconds            (time_in_seconds)
#  index_workouts_on_total_time_in_seconds      (total_time_in_seconds)
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

