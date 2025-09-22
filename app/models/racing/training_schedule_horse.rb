module Racing
  class TrainingScheduleHorse < ApplicationRecord
    self.table_name = "training_schedules_horses"

    belongs_to :training_schedule, class_name: "Racing::TrainingSchedule"
    belongs_to :horse, class_name: "Horses::Horse"

    delegate :stable, to: :training_schedule

    validates :horse_id, uniqueness: true # rubocop:disable Rails/UniqueValidationWithoutIndex

    counter_culture :training_schedule, column_name: :horses_count
  end
end

# == Schema Information
#
# Table name: training_schedules_horses
#
#  id                   :integer          not null, primary key
#  training_schedule_id :uuid             not null, indexed
#  horse_id             :uuid             not null, indexed
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_training_schedules_horses_on_horse_id              (horse_id) UNIQUE
#  index_training_schedules_horses_on_training_schedule_id  (training_schedule_id)
#

