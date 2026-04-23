module Workouts
  class JumpTrial < ApplicationRecord
    include Timeable

    belongs_to :horse, class_name: "Horses::Horse"
    belongs_to :jockey, class_name: "Racing::Jockey"
    belongs_to :racetrack, class_name: "Racing::Racetrack"
    belongs_to :comment, inverse_of: :jump_trials

    validates :condition, :distance, :time_in_seconds, :date, presence: true

    def self.ransackable_attributes(_auth_object = nil)
      %w[comment_id condition date distance horse_id jockey_id racetrack_id time_in_seconds]
    end
  end
end

# == Schema Information
#
# Table name: jump_trials
# Database name: primary
#
#  id              :bigint           not null, primary key
#  condition       :enum             not null
#  date            :date             not null, uniquely indexed => [horse_id]
#  distance        :integer          default(0), not null
#  time_in_seconds :integer          default(0), not null, indexed
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  comment_id      :bigint           not null, indexed
#  horse_id        :bigint           not null, uniquely indexed => [date]
#  jockey_id       :bigint           not null, indexed
#  racetrack_id    :bigint           not null, indexed
#
# Indexes
#
#  index_jump_trials_on_comment_id         (comment_id)
#  index_jump_trials_on_horse_id_and_date  (horse_id,date) UNIQUE
#  index_jump_trials_on_jockey_id          (jockey_id)
#  index_jump_trials_on_racetrack_id       (racetrack_id)
#  index_jump_trials_on_time_in_seconds    (time_in_seconds)
#
# Foreign Keys
#
#  fk_rails_...  (comment_id => workout_comments.id)
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (jockey_id => jockeys.id)
#  fk_rails_...  (racetrack_id => racetracks.id)
#

