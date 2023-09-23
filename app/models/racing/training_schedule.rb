module Racing
  class TrainingSchedule < ApplicationRecord
    include StoreModel::NestedAttributes

    MAX_SCHEDULES_PER_STABLE = 10

    belongs_to :stable, class_name: "Account::Stable"

    has_many :training_schedule_horses, class_name: "Racing::TrainingScheduleHorse", inverse_of: :training_schedule, dependent: :destroy
    has_many :horses, class_name: "Horses::Horse", through: :training_schedule_horses

    attribute :sunday_activities, TrainingScheduleActivity.to_type
    attribute :monday_activities, TrainingScheduleActivity.to_type
    attribute :tuesday_activities, TrainingScheduleActivity.to_type
    attribute :wednesday_activities, TrainingScheduleActivity.to_type
    attribute :thursday_activities, TrainingScheduleActivity.to_type
    attribute :friday_activities, TrainingScheduleActivity.to_type
    attribute :saturday_activities, TrainingScheduleActivity.to_type

    accepts_nested_attributes_for :sunday_activities, :monday_activities, :tuesday_activities,
      :wednesday_activities, :thursday_activities, :friday_activities,
      :saturday_activities, allow_destroy: true

    validates :name, uniqueness: { scope: :stable_id, case_sensitive: false }
    validates :sunday_activities, store_model: true
    validates :monday_activities, store_model: true
    validates :tuesday_activities, store_model: true
    validates :wednesday_activities, store_model: true
    validates :thursday_activities, store_model: true
    validates :friday_activities, store_model: true
    validates :saturday_activities, store_model: true
    validate :minimum_activities

    private

    def all_activities
      [sunday_activities, monday_activities, tuesday_activities, wednesday_activities, thursday_activities,
        friday_activities, saturday_activities]
    end

    def minimum_activities
      return if all_activities.any? { |activity| activity.activity1.present? && activity.distance1.present? }

      errors.add(:base, :missing_activities)
    end

    # 2yo schedule
    # Max gallop	1 mile
    # Max workout (all activities)	2 miles
  end
end

# == Schema Information
#
# Table name: training_schedules
#
#  id                   :uuid             not null, primary key
#  description          :text
#  friday_activities    :jsonb            not null, indexed
#  horses_count         :integer          default(0), not null
#  monday_activities    :jsonb            not null, indexed
#  name                 :string           not null
#  saturday_activities  :jsonb            not null, indexed
#  sunday_activities    :jsonb            not null, indexed
#  thursday_activities  :jsonb            not null, indexed
#  tuesday_activities   :jsonb            not null, indexed
#  wednesday_activities :jsonb            not null, indexed
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  stable_id            :uuid             not null, indexed
#
# Indexes
#
#  index_training_schedules_on_friday_activities     (friday_activities) USING gin
#  index_training_schedules_on_monday_activities     (monday_activities) USING gin
#  index_training_schedules_on_saturday_activities   (saturday_activities) USING gin
#  index_training_schedules_on_stable_id             (stable_id)
#  index_training_schedules_on_sunday_activities     (sunday_activities) USING gin
#  index_training_schedules_on_thursday_activities   (thursday_activities) USING gin
#  index_training_schedules_on_tuesday_activities    (tuesday_activities) USING gin
#  index_training_schedules_on_wednesday_activities  (wednesday_activities) USING gin
#

