module Racing
  class TrainingScheduleHorse < ApplicationRecord
    self.table_name = "training_schedules_horses"

    belongs_to :training_schedule, class_name: "Racing::TrainingSchedule"
    belongs_to :horse, class_name: "Horses::Horse::Racehorse"

    delegate :stable, to: :training_schedule

    validates :horse_id, uniqueness: true # rubocop:disable Rails/UniqueValidationWithoutIndex
    validate :schedule_valid_for_horse

    counter_culture :training_schedule, column_name: :horses_count

    private

    def schedule_valid_for_horse
      return if training_schedule.blank?
      return if horse.blank?
      return if training_schedule.valid_for_age?(horse.age)

      errors.add(:training_schedule, :invalid)
    end
  end
end

# == Schema Information
#
# Table name: training_schedules_horses
# Database name: primary
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  horse_id             :bigint           not null, uniquely indexed
#  training_schedule_id :bigint           not null, indexed
#
# Indexes
#
#  index_training_schedules_horses_on_horse_id              (horse_id) UNIQUE
#  index_training_schedules_horses_on_training_schedule_id  (training_schedule_id)
#
# Foreign Keys
#
#  fk_rails_...  (horse_id => horses.id) ON DELETE => cascade ON UPDATE => cascade
#  fk_rails_...  (training_schedule_id => training_schedules.id) ON DELETE => cascade ON UPDATE => cascade
#

