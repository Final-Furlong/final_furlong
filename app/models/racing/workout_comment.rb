module Racing
  class WorkoutComment < ApplicationRecord
    validates :stat, presence: true
  end
end

# == Schema Information
#
# Table name: workout_comments
# Database name: primary
#
#  id               :bigint           not null, primary key
#  comment_i18n_key :string
#  placeholders     :string
#  stat             :enum             not null, indexed
#  stat_value       :integer          indexed
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_workout_comments_on_stat        (stat)
#  index_workout_comments_on_stat_value  (stat_value)
#

