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
#  id                   :bigint           not null, primary key
#  description          :text
#  friday_activities    :string           not null, indexed
#  horses_count         :integer          default(0), not null, indexed
#  monday_activities    :string           not null, indexed
#  name                 :string           not null
#  saturday_activities  :string           not null, indexed
#  sunday_activities    :string           not null, indexed
#  thursday_activities  :string           not null, indexed
#  tuesday_activities   :string           not null, indexed
#  wednesday_activities :string           not null, indexed
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  old_id               :uuid             indexed
#  old_stable_id        :uuid             not null, indexed
#  stable_id            :integer          indexed
#
# Indexes
#
#  index_training_schedules_on_friday_activities     (friday_activities)
#  index_training_schedules_on_horses_count          (horses_count)
#  index_training_schedules_on_monday_activities     (monday_activities)
#  index_training_schedules_on_old_id                (old_id)
#  index_training_schedules_on_old_stable_id         (old_stable_id)
#  index_training_schedules_on_saturday_activities   (saturday_activities)
#  index_training_schedules_on_stable_id             (stable_id)
#  index_training_schedules_on_sunday_activities     (sunday_activities)
#  index_training_schedules_on_thursday_activities   (thursday_activities)
#  index_training_schedules_on_tuesday_activities    (tuesday_activities)
#  index_training_schedules_on_wednesday_activities  (wednesday_activities)
#
# Foreign Keys
#
#  fk_rails_...  (stable_id => stables.id) ON DELETE => cascade ON UPDATE => cascade
#

