module Racing
  class TrainingSchedule < ApplicationRecord
    include StoreModel::NestedAttributes

    WEEKDAYS = %w[sunday monday tuesday wednesday thursday friday saturday].freeze

    belongs_to :stable, class_name: "Account::Stable"

    has_many :training_schedule_horses, class_name: "Racing::TrainingScheduleHorse", inverse_of: :training_schedule, dependent: :destroy

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

    validates :name, presence: true, uniqueness: { scope: :stable_id, case_sensitive: false }
    validates :sunday_activities, store_model: true
    validates :monday_activities, store_model: true
    validates :tuesday_activities, store_model: true
    validates :wednesday_activities, store_model: true
    validates :thursday_activities, store_model: true
    validates :friday_activities, store_model: true
    validates :saturday_activities, store_model: true
    validate :minimum_activities

    scope :with_activities, ->(weekday) {
      if WEEKDAYS.include?(weekday)
        where.not("#{weekday.downcase}_activities" => { activity1: nil, activity2: nil, activity3: nil, distance1: nil, distance2: nil, distance3: nil }.to_json)
      else
        none
      end
    }
    scope :without_activities, ->(weekday) {
      if WEEKDAYS.include?(weekday)
        where("#{weekday.downcase}_activities" => { activity1: nil, activity2: nil, activity3: nil, distance1: nil, distance2: nil, distance3: nil }.to_json)
      else
        none
      end
    }
    scope :valid_for_horse, ->(horse) {
      if horse.age > 2
        where(stable_id: horse.manager_id)
      else
        where(stable_id: horse.manager_id).max_gallop(Config::Workouts.max_gallop_for_2yos).max_distance(Config::Workouts.max_distance_for_2yos)
      end
    }
    scope :max_gallop, ->(value) {
      where(
        "(sunday_activities->>'activity1' != :activity OR (sunday_activities->>'activity1' = :activity AND COALESCE(CAST(sunday_activities->>'distance1' AS integer), 0) <= :distance)) AND
        (sunday_activities->>'activity2' != :activity OR (sunday_activities->>'activity2' = :activity AND COALESCE(CAST(sunday_activities->>'distance2' AS integer), 0) <= :distance)) AND
        (sunday_activities->>'activity3' != :activity OR (sunday_activities->>'activity3' = :activity AND COALESCE(CAST(sunday_activities->>'distance3' AS integer), 0) <= :distance)) AND
        (monday_activities->>'activity1' != :activity OR (monday_activities->>'activity1' = :activity AND COALESCE(CAST(monday_activities->>'distance1' AS integer), 0) <= :distance)) AND
        (monday_activities->>'activity2' != :activity OR (monday_activities->>'activity2' = :activity AND COALESCE(CAST(monday_activities->>'distance2' AS integer), 0) <= :distance)) AND
        (monday_activities->>'activity3' != :activity OR (monday_activities->>'activity3' = :activity AND COALESCE(CAST(monday_activities->>'distance3' AS integer), 0) <= :distance)) AND
        (tuesday_activities->>'activity1' != :activity OR (tuesday_activities->>'activity1' = :activity AND COALESCE(CAST(tuesday_activities->>'distance1' AS integer), 0) <= :distance)) AND
        (tuesday_activities->>'activity2' != :activity OR (tuesday_activities->>'activity2' = :activity AND COALESCE(CAST(tuesday_activities->>'distance2' AS integer), 0) <= :distance)) AND
        (tuesday_activities->>'activity3' != :activity OR (tuesday_activities->>'activity3' = :activity AND COALESCE(CAST(tuesday_activities->>'distance3' AS integer), 0) <= :distance)) AND
        (wednesday_activities->>'activity1' != :activity OR (wednesday_activities->>'activity1' = :activity AND COALESCE(CAST(wednesday_activities->>'distance1' AS integer), 0) <= :distance)) AND
        (wednesday_activities->>'activity2' != :activity OR (wednesday_activities->>'activity2' = :activity AND COALESCE(CAST(wednesday_activities->>'distance2' AS integer), 0) <= :distance)) AND
        (wednesday_activities->>'activity3' != :activity OR (wednesday_activities->>'activity3' = :activity AND COALESCE(CAST(wednesday_activities->>'distance3' AS integer), 0) <= :distance)) AND
        (thursday_activities->>'activity1' != :activity OR (thursday_activities->>'activity1' = :activity AND COALESCE(CAST(thursday_activities->>'distance1' AS integer), 0) <= :distance)) AND
        (thursday_activities->>'activity2' != :activity OR (thursday_activities->>'activity2' = :activity AND COALESCE(CAST(thursday_activities->>'distance2' AS integer), 0) <= :distance)) AND
        (thursday_activities->>'activity3' != :activity OR (thursday_activities->>'activity3' = :activity AND COALESCE(CAST(thursday_activities->>'distance3' AS integer), 0) <= :distance)) AND
        (friday_activities->>'activity1' != :activity OR (friday_activities->>'activity1' = :activity AND COALESCE(CAST(friday_activities->>'distance1' AS integer), 0) <= :distance)) AND
        (friday_activities->>'activity2' != :activity OR (friday_activities->>'activity2' = :activity AND COALESCE(CAST(friday_activities->>'distance2' AS integer), 0) <= :distance)) AND
        (friday_activities->>'activity3' != :activity OR (friday_activities->>'activity3' = :activity AND COALESCE(CAST(friday_activities->>'distance3' AS integer), 0) <= :distance)) AND
        (saturday_activities->>'activity1' != :activity OR (saturday_activities->>'activity1' = :activity AND COALESCE(CAST(saturday_activities->>'distance1' AS integer), 0) <= :distance)) AND
        (saturday_activities->>'activity2' != :activity OR (saturday_activities->>'activity2' = :activity AND COALESCE(CAST(saturday_activities->>'distance2' AS integer), 0) <= :distance)) AND
        (saturday_activities->>'activity3' != :activity OR (saturday_activities->>'activity3' = :activity AND COALESCE(CAST(saturday_activities->>'distance3' AS integer), 0) <= :distance))",
        { activity: "gallop", distance: value }
      )
    }
    scope :max_distance, ->(value) {
      where(
        "COALESCE(CAST(sunday_activities->>'distance1' AS integer) + CAST(sunday_activities->>'distance2' AS integer) + CAST(sunday_activities->>'distance3' AS integer), 0) <= :distance AND
        COALESCE(CAST(monday_activities->>'distance1' AS integer) + CAST(monday_activities->>'distance2' AS integer) + CAST(monday_activities->>'distance3' AS integer), 0) <= :distance AND
        COALESCE(CAST(tuesday_activities->>'distance1' AS integer) + CAST(tuesday_activities->>'distance2' AS integer) + CAST(tuesday_activities->>'distance3' AS integer), 0) <= :distance AND
        COALESCE(CAST(wednesday_activities->>'distance1' AS integer) + CAST(wednesday_activities->>'distance2' AS integer) + CAST(wednesday_activities->>'distance3' AS integer), 0) <= :distance AND
        COALESCE(CAST(thursday_activities->>'distance1' AS integer) + CAST(thursday_activities->>'distance2' AS integer) + CAST(thursday_activities->>'distance3' AS integer), 0) <= :distance AND
        COALESCE(CAST(friday_activities->>'distance1' AS integer) + CAST(friday_activities->>'distance2' AS integer) + CAST(friday_activities->>'distance3' AS integer), 0) <= :distance AND
        COALESCE(CAST(saturday_activities->>'distance1' AS integer) + CAST(saturday_activities->>'distance2' AS integer) + CAST(saturday_activities->>'distance3' AS integer), 0) <= :distance",
        { distance: value }
      )
    }

    def daily_activities
      weekday = Time.zone.today.strftime("%A")
      send(:"#{weekday.downcase}_activities")
    end

    def valid_for_age?(age)
      return true if age > 2

      WEEKDAYS.all? do |weekday|
        send("#{weekday.downcase}_activities").blank? || send("#{weekday.downcase}_activities").valid_for_2yo?
      end
    end

    private

    def all_activities
      [sunday_activities, monday_activities, tuesday_activities, wednesday_activities, thursday_activities,
        friday_activities, saturday_activities]
    end

    def minimum_activities
      return if all_activities.compact.any? { |activity| activity.activity1.present? && activity.distance1.present? }

      errors.add(:base, :missing_activities)
    end
  end
end

# == Schema Information
#
# Table name: training_schedules
# Database name: primary
#
#  id                   :bigint           not null, primary key
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
#  stable_id            :bigint           not null, indexed
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
#  fk_rails_...  (stable_id => stables.id) ON DELETE => cascade ON UPDATE => cascade
#

