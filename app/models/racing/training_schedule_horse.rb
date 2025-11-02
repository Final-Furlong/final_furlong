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
#  id                       :bigint           not null, primary key
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  horse_id                 :bigint           not null, uniquely indexed
#  old_horse_id             :uuid             not null, indexed
#  old_id                   :uuid             indexed
#  old_training_schedule_id :uuid             not null, indexed
#  training_schedule_id     :bigint           not null, indexed
#
# Indexes
#
#  index_training_schedules_horses_on_horse_id                  (horse_id) UNIQUE
#  index_training_schedules_horses_on_old_horse_id              (old_horse_id)
#  index_training_schedules_horses_on_old_id                    (old_id)
#  index_training_schedules_horses_on_old_training_schedule_id  (old_training_schedule_id)
#  index_training_schedules_horses_on_training_schedule_id      (training_schedule_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id) ON DELETE => cascade ON UPDATE => cascade
#  fk_rails_...  (training_schedule_id => training_schedules.id) ON DELETE => cascade ON UPDATE => cascade
#

