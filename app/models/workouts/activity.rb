module Workouts
  class Activity < ApplicationRecord
    self.table_name = "workout_activities"

    belongs_to :workout, inverse_of: :activities

    validates :activity, :distance, :activity_index, presence: true
    validates :activity, inclusion: { in: Config::Workouts.activities.map(&:downcase) }
    validates :distance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :time_in_seconds, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

    validates :distance, numericality: { greater_than: Config::Workouts.dig(:walk, :min_furlongs) - 1, less_than: Config::Workouts.dig(:walk, :max_furlongs) + 1 }, if: -> { activity == "walk" }
    validates :distance, numericality: { greater_than: Config::Workouts.dig(:jog, :min_furlongs) - 1, less_than: Config::Workouts.dig(:jog, :max_furlongs) + 1 }, if: -> { activity == "jog" }
    validates :distance, numericality: { greater_than: Config::Workouts.dig(:canter, :min_furlongs) - 1, less_than: Config::Workouts.dig(:canter, :max_furlongs) + 1 }, if: -> { activity == "canter" }
    validates :distance, numericality: { greater_than: Config::Workouts.dig(:gallop, :min_furlongs) - 1, less_than: Config::Workouts.dig(:gallop, :max_furlongs) + 1 }, if: -> { activity == "gallop" }
    validates :distance, numericality: { greater_than: Config::Workouts.dig(:breeze, :min_furlongs) - 1, less_than: Config::Workouts.dig(:breeze, :max_furlongs) + 1 }, if: -> { activity == "breeze" }

    scope :by_activity, ->(activity) { where(activity:) }
    scope :with_time, -> { where.not(time_in_seconds: nil) }

    def activity_string
      distance_i18n = I18n.t("common.distances.#{distance}_furlongs")
      "#{activity.capitalize} (#{distance_i18n})"
    end

    def activity_time
      return if time_in_seconds.to_i.zero?

      time_string(time)
    end

    def time_string(seconds)
      minutes = (seconds / 60).floor
      seconds = (seconds % 60).floor
      [minutes, "%02d" % seconds].join(":")
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[activity distance time_in_seconds]
    end
  end
end

# == Schema Information
#
# Table name: workout_activities
# Database name: primary
#
#  id                                          :bigint           not null, primary key
#  activity(walk, jog, canter, gallop, breeze) :enum             not null, indexed, uniquely indexed => [workout_id]
#  activity_index                              :integer          default(1), not null, indexed, uniquely indexed => [workout_id]
#  distance                                    :integer          default(0), not null, indexed
#  time_in_seconds                             :integer          indexed
#  created_at                                  :datetime         not null
#  updated_at                                  :datetime         not null
#  workout_id                                  :bigint           not null, uniquely indexed => [activity], uniquely indexed => [activity_index]
#
# Indexes
#
#  index_workout_activities_on_activity                       (activity)
#  index_workout_activities_on_activity_index                 (activity_index)
#  index_workout_activities_on_distance                       (distance)
#  index_workout_activities_on_time_in_seconds                (time_in_seconds)
#  index_workout_activities_on_workout_id_and_activity        (workout_id,activity) UNIQUE
#  index_workout_activities_on_workout_id_and_activity_index  (workout_id,activity_index) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (workout_id => workouts.id)
#

