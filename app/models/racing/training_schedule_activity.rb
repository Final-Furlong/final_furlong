module Racing
  class TrainingScheduleActivity
    include StoreModel::Model

    VALID_ACTIVITIES = %w[walk jog canter gallop breeze].freeze
    VALID_DISTANCES = [
      1, 2, 3, 4, 5, 6, 8, 12, 16, 20, 24, 28, 32, 36, 40
    ].freeze

    attribute :activity1, :string
    attribute :activity2, :string
    attribute :activity3, :string

    attribute :distance1, :integer
    attribute :distance2, :integer
    attribute :distance3, :integer

    validates :activity1, :activity2, :activity3, inclusion: { in: VALID_ACTIVITIES }, allow_blank: true
    validates :distance1, :distance2, :distance3, inclusion: { in: VALID_DISTANCES }, allow_blank: true

    def self.localised_activities
      VALID_ACTIVITIES.map do |activity|
        [I18n.t("current_stable.training_schedules.activities.#{activity}"), activity]
      end
    end

    def self.localised_distances
      VALID_DISTANCES.map do |distance|
        [I18n.t("common.distances.#{distance}_furlongs"), distance]
      end
    end

    def blank?
      activity1.blank? && activity2.blank? && activity3.blank?
    end

    def activity_with_distance(index)
      activity = send("activity#{index}").titleize
      return I18n.t("common.none") if activity.blank?

      distance = I18n.t("common.distances.#{send("distance#{index}")}_furlongs")
      I18n.t("racing.training_schedules.activity_with_distance", activity:, distance:)
    end
  end
end

