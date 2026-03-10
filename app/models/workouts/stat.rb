module Workouts
  class Stat < ApplicationRecord
    self.table_name = "workout_stats"

    belongs_to :horse, class_name: "Horses::Horse", inverse_of: :workout_stats

    validates :activity, inclusion: { in: Config::Workouts.activities.map(&:downcase) }
    validates :best_time_in_seconds, comparison: { less_than_or_equal_to: :recent_time_in_seconds }
    validates :best_time_in_seconds, :recent_time_in_seconds, numericality: { greater_than_or_equal_to: 0 }
    validates :activity, uniqueness: { scope: :horse_id }
  end
end

# == Schema Information
#
# Table name: workout_stats
# Database name: primary
#
#  id                                          :bigint           not null, primary key
#  activity(walk, jog, canter, gallop, breeze) :enum             not null, indexed, uniquely indexed => [horse_id]
#  best_date                                   :date             not null, indexed
#  best_time_in_seconds                        :integer          default(0), not null, indexed
#  recent_date                                 :date             not null, indexed
#  recent_time_in_seconds                      :integer          default(0), not null, indexed
#  created_at                                  :datetime         not null
#  updated_at                                  :datetime         not null
#  horse_id                                    :bigint           not null, uniquely indexed => [activity]
#
# Indexes
#
#  index_workout_stats_on_activity                (activity)
#  index_workout_stats_on_best_date               (best_date)
#  index_workout_stats_on_best_time_in_seconds    (best_time_in_seconds)
#  index_workout_stats_on_horse_id_and_activity   (horse_id,activity) UNIQUE
#  index_workout_stats_on_recent_date             (recent_date)
#  index_workout_stats_on_recent_time_in_seconds  (recent_time_in_seconds)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#

