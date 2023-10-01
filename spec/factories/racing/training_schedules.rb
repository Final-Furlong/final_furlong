FactoryBot.define do
  factory :training_schedule, class: "Racing::TrainingSchedule" do
    sequence(:name) { |n| "Training Schedule_#{n}" }
    friday_activities do
      { activity1: "canter", activity2: "", activity3: "", distance1: 4, distance2: nil, distance3: nil }
    end
    stable { association :stable }
  end

  factory :training_schedule_horse, class: "Racing::TrainingScheduleHorse" do
    training_schedule { association :training_schedule }
    horse { association :horse, owner: instance.training_schedule.stable }
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
#  index_training_schedules_on_lowercase_name        (stable_id, lower((name)::text)) UNIQUE
#  index_training_schedules_on_monday_activities     (monday_activities) USING gin
#  index_training_schedules_on_saturday_activities   (saturday_activities) USING gin
#  index_training_schedules_on_stable_id             (stable_id)
#  index_training_schedules_on_sunday_activities     (sunday_activities) USING gin
#  index_training_schedules_on_thursday_activities   (thursday_activities) USING gin
#  index_training_schedules_on_tuesday_activities    (tuesday_activities) USING gin
#  index_training_schedules_on_wednesday_activities  (wednesday_activities) USING gin
#
# Foreign Keys
#
#  fk_rails_...  (stable_id => stables.id)
#

