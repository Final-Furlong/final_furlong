module Racing
  class TrainingScheduleHorse < ApplicationRecord
    self.table_name = "training_schedules_horses"

    belongs_to :training_schedule, class_name: "Racing::TrainingSchedule"
    belongs_to :horse, class_name: "Horses::Horse"

    validates :horse_id, uniqueness: true # rubocop:disable Rails/UniqueValidationWithoutIndex

    counter_culture :training_schedule, column_name: :horses_count
  end
end

# == Schema Information
#
# Table name: training_schedules_horses
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  horse_id             :uuid             indexed
#  training_schedule_id :uuid             indexed
#
# Indexes
#
#  index_training_schedules_horses_on_horse_id              (horse_id) UNIQUE
#  index_training_schedules_horses_on_training_schedule_id  (training_schedule_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id)
#  fk_rails_...  (training_schedule_id => training_schedules.id)
#

