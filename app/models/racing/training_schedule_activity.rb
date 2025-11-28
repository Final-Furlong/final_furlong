module Racing
  class TrainingScheduleActivity
    include StoreModel::Model

    attribute :activity1, :string
    attribute :activity2, :string
    attribute :activity3, :string

    attribute :distance1, :integer
    attribute :distance2, :integer
    attribute :distance3, :integer

    validates :activity1, :activity2, :activity3, inclusion: { in: Config::Workouts.activities }, allow_blank: true
    validates :distance1, :distance2, :distance3, inclusion: { in: Config::Workouts.distances }, allow_blank: true

    validates :distance1, inclusion: { in: Config::Workouts.dig(:walk, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_walk") }, if: :walking_activity1?
    validates :distance1, inclusion: { in: Config::Workouts.dig(:jog, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_jog") }, if: :jogging_activity1?
    validates :distance1, inclusion: { in: Config::Workouts.dig(:canter, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_canter") }, if: :cantering_activity1?
    validates :distance1, inclusion: { in: Config::Workouts.dig(:gallop, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_gallop") }, if: :galloping_activity1?
    validates :distance1, inclusion: { in: Config::Workouts.dig(:breeze, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_breeze") }, if: :breezing_activity1?

    validates :distance2, inclusion: { in: Config::Workouts.dig(:walk, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_walk") }, if: :walking_activity2?
    validates :distance2, inclusion: { in: Config::Workouts.dig(:jog, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_jog") }, if: :jogging_activity2?
    validates :distance2, inclusion: { in: Config::Workouts.dig(:canter, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_canter") }, if: :cantering_activity2?
    validates :distance2, inclusion: { in: Config::Workouts.dig(:gallop, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_gallop") }, if: :galloping_activity2?
    validates :distance2, inclusion: { in: Config::Workouts.dig(:breeze, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_breeze") }, if: :breezing_activity2?

    validates :distance3, inclusion: { in: Config::Workouts.dig(:walk, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_walk") }, if: :walking_activity3?
    validates :distance3, inclusion: { in: Config::Workouts.dig(:jog, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_jog") }, if: :jogging_activity3?
    validates :distance3, inclusion: { in: Config::Workouts.dig(:canter, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_canter") }, if: :cantering_activity3?
    validates :distance3, inclusion: { in: Config::Workouts.dig(:gallop, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_gallop") }, if: :galloping_activity3?
    validates :distance3, inclusion: { in: Config::Workouts.dig(:breeze, :distances), message: I18n.t("activerecord.errors.models.racing/training_schedule_activity.attributes.activity1.invalid_breeze") }, if: :breezing_activity3?

    def self.localised_activities
      Config::Workouts.activities.map do |activity|
        [I18n.t("current_stable.training_schedules.activities.#{activity}"), activity]
      end
    end

    def self.localised_distances
      Config::Workouts.distances.map do |distance|
        [I18n.t("common.distances.#{distance}_furlongs"), distance]
      end
    end

    def blank?
      activity1.blank? && activity2.blank? && activity3.blank?
    end

    def activity_with_distance(index)
      activity = send(:"activity#{index}")
      return I18n.t("common.none") if activity.blank?

      distance = I18n.t("common.distances.#{send(:"distance#{index}")}_furlongs")
      I18n.t("racing.training_schedules.activity_with_distance", activity: activity.titleize, distance:)
    end

    def method_missing(name, *args, &block)
      if (match = name.match(/(walking|jogging|cantering|galloping|breezing)_activity(1|2|3)\?/))
        activity = match.captures.first.gsub(/g?ing\z/, "")
        send(:"activity#{match.captures.last}") == activity
      else
        super
      end
    end

    def respond_to_missing?(name, *args, &block)
      /(walking|jogging|cantering|galloping|breezing)_activity(1|2|3)\?/.match?(name) || super
    end
  end
end

