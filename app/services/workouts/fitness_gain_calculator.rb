class Workouts::FitnessGainCalculator
  attr_reader :activity

  def initialize(activity)
    @activity = activity
  end

  def call
    case activity.downcase.to_sym
    when :walk
      rand(0.0045..0.0061)
    when :jog, :trot
      rand(0.0182..0.0318)
    when :canter
      rand(0.0758..0.0909)
    when :gallop
      rand(0.2879..0.3182)
    when :breeze
      rand(0.5..0.5455)
    else
      raise ArgumentError, "Unrecognized activity: #{activity}"
    end
  end
end

