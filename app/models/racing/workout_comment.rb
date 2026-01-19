module Racing
  class WorkoutComment < ApplicationRecord
    self.table_name = "workout_comments"

    # has_many :workouts, class_name: "Racing::Workout", inverse_of: :comment, dependent: :nullify

    validates :stat, presence: true

    def to_s(name, female = false)
      if placeholders.blank?
        I18n.t("racing.workout_comments.#{comment_i18n_key}")
      elsif placeholders == "name"
        I18n.t("racing.workout_comments.#{comment_i18n_key}", name:)
      else
        gender = I18n.t("racing.workout_comments.gender_#{female ? "female" : "male"}")
        I18n.t("racing.workout_comments.#{comment_i18n_key}", name:, gender:)
      end
    end
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

