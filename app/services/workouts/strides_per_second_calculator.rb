class Workouts::StridesPerSecondCalculator
  attr_reader :activity, :strides_per_second, :effort, :weight_modifier, :equipment_status_modifier, :track_preference_modifier,
    :track_condition_modifier, :consistency_modifier

  def initialize(activity:, strides_per_second:, effort:, weight:, equipment_status:, track_preference:,
    track_condition:, consistency:)
    @activity = activity
    @strides_per_second = strides_per_second
    @effort = effort
    @weight_modifier = weight
    @equipment_status_modifier = equipment_status
    @track_preference_modifier = track_preference
    @track_condition_modifier = track_condition
    @consistency_modifier = consistency
    raise ArgumentError, "Invalid effort: #{effort}" unless effort.between?(0, 100)
    raise ArgumentError, "Invalid weight modifier: #{weight}" unless weight.between?(0.0, 2.0)
    raise ArgumentError, "Invalid equipment status modifier: #{equipment_status}" unless equipment_status.between?(0.9, 1.1)
    raise ArgumentError, "Invalid track preference modifier: #{track_preference}" unless track_preference.between?(0.96, 1.05)
    raise ArgumentError, "Invalid track condition modifier: #{track_condition}" unless track_condition.between?(0.96, 1.05)
    raise ArgumentError, "Invalid consistency modifier: #{consistency}" unless consistency.between?(0.8, 0.99)
  end

  def call
    base_value = case activity.downcase.to_sym
    when :walk
      rand(10.0..20.0)
    when :jog, :trot
      rand(20.0..30.0)
    when :canter
      rand(15.0..20.0)
    when :gallop
      strides_per_second * random_percent
    when :breeze
      strides_per_second * random_percent
    else
      raise ArgumentError, "Unrecognized activity: #{activity}"
    end
    effort_value = base_value * (effort / 100)
    weight_value = effort_value * weight_modifier
    equipment_value = weight_value * equipment_status_modifier
    track_preference_value = equipment_value * track_preference_modifier
    track_condition_value = track_preference_value * track_condition_modifier
    track_condition_value * consistency_modifier
  end

  private

  def random_percent
    rand(0.89..0.99)
  end
end

