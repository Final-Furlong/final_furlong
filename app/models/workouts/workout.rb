module Workouts
  class Workout < ApplicationRecord
    include Equipmentable

    self.table_name = "workouts"
    self.ignored_columns += ["rank", "activity1", "distance1",
      "activity1_time_in_seconds", "activity2",
      "activity2_time_in_seconds", "activity3",
      "activity3_time_in_seconds", "distance2",
      "distance3", "total_time_in_seconds"]

    attr_accessor :special_event_type, :special_event_time, :confidence,
      :energy_loss, :fitness_gain

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :jockey, class_name: "Racing::Jockey"
    belongs_to :location
    belongs_to :racetrack, class_name: "Racing::Racetrack"
    belongs_to :surface, class_name: "Racing::TrackSurface"
    belongs_to :comment, optional: true, inverse_of: :workouts
    has_many :activities, class_name: "Activity", dependent: :delete_all

    validates :activities, :condition, :date, :effort, :equipment, presence: true
    validates :confidence, :comment, presence: true, on: :complete_workout
    validates :condition, inclusion: { in: Config::Racing.conditions.map(&:downcase) }
    validates :effort, numericality: { only_integer: true, greater_than: 0 }
    validates :confidence, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, on: :complete_workout
    validates :equipment, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :time_in_seconds, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true, on: :complete_workout
    validates :auto, :special_event, inclusion: { in: [true, false] }
    validates :horse_id, uniqueness: { scope: :date }

    validate :valid_baby_distances, :valid_activity_list

    accepts_nested_attributes_for :activities, reject_if: lambda { |attributes| attributes["activity"].blank? || attributes["distance"].blank? }

    def surface_name
      surface&.surface
    end

    def options_for_effort_select
      levels = Config::Workouts.effort_levels.sort.reverse
      levels.map do |level|
        [I18n.t("horse.workouts.form.effort_#{level}"), level]
      end
    end

    def options_for_surface_select
      horse.race_options.surface_options.map do |surface|
        [I18n.t("horse.workouts.form.surface_#{surface}"), surface]
      end
    end

    def store_initial_options(schedule)
      activities = schedule.daily_activities
      self.activities << self.activities.build(activity: activities.activity1, distance: activities.distance1, activity_index: 1)
      self.activities << self.activities.build(activity: activities.activity2, distance: activities.distance2, activity_index: 2)
      self.activities << self.activities.build(activity: activities.activity3, distance: activities.distance3, activity_index: 3)
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
      horse_age = date.year - horse.date_of_birth.year
      return if horse_age > 2

      total_distance = 0
      activities.each do |activity|
        if activity&.distance
          total_distance += activity.distance.to_i
          if activity.activity == "gallop" && activity.distance.to_i > Config::Workouts.max_gallop_for_2yos
            errors.add(:activities, :less_than, count: Config::Workouts.max_gallop_for_2yos)
          end
        end
      end
      return if total_distance <= Config::Workouts.max_distance_for_2yos

      errors.add(:base, :distance_too_long_for_2yo)
    end

    def valid_activity_list
      chosen_activities = activities.select { |activity| activity.activity.present? && activity.distance.present? }
      unique_activities = []
      return if chosen_activities.size == 1

      chosen_activities.each { |activity| unique_activities.push(activity.activity) }
      return if unique_activities.size == unique_activities.uniq.size

      errors.add(:base, :duplicate_activities)
    end

    def activity_string(key)
      activity = activities.find_by(activity_index: key)
      return I18n.t("common.dash") if activity.blank?

      distance_i18n = I18n.t("common.distances.#{activity.distance}_furlongs")
      "#{activity.activity.capitalize} (#{distance_i18n})"
    end

    def activity_time(key)
      if key == :total
        method = "time_in_seconds" if key == :total
        time = send(:"#{method}")
      else
        time = activities.find_by(activity_index: key)&.time_in_seconds
      end
      return if time.to_i.zero?

      time_string(time)
    end

    def time_string(seconds)
      minutes = (seconds / 60).floor
      seconds = (seconds % 60).floor
      [minutes, "%02d" % seconds].join(":")
    end

    def activity_count
      activities.size
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[comment_id condition confidence date effort equipment horse_id jockey_id time_in_seconds]
    end
  end
end

# == Schema Information
#
# Table name: workouts
# Database name: primary
#
#  id                               :bigint           not null, primary key
#  auto                             :boolean          default(FALSE), not null, indexed
#  condition(fast, good, slow, wet) :enum             not null, indexed
#  confidence                       :integer          default(0), not null, indexed
#  date                             :date             not null, indexed, uniquely indexed => [horse_id]
#  effort                           :integer          default(0), not null, indexed
#  equipment                        :integer          default(0), not null, indexed
#  special_event                    :boolean          default(FALSE), not null, indexed
#  time_in_seconds                  :integer          indexed
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  comment_id                       :bigint           not null, indexed
#  horse_id                         :bigint           not null, uniquely indexed => [date]
#  jockey_id                        :bigint           not null, indexed
#  location_id                      :bigint           not null, indexed
#  racetrack_id                     :bigint           not null, indexed
#  surface_id                       :bigint           not null, indexed
#
# Indexes
#
#  index_workouts_on_auto               (auto)
#  index_workouts_on_comment_id         (comment_id)
#  index_workouts_on_condition          (condition)
#  index_workouts_on_confidence         (confidence)
#  index_workouts_on_date               (date)
#  index_workouts_on_effort             (effort)
#  index_workouts_on_equipment          (equipment)
#  index_workouts_on_horse_id_and_date  (horse_id,date) UNIQUE
#  index_workouts_on_jockey_id          (jockey_id)
#  index_workouts_on_location_id        (location_id)
#  index_workouts_on_racetrack_id       (racetrack_id)
#  index_workouts_on_special_event      (special_event)
#  index_workouts_on_surface_id         (surface_id)
#  index_workouts_on_time_in_seconds    (time_in_seconds)
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

