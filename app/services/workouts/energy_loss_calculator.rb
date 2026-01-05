class Workouts::EnergyLossCalculator
  attr_reader :activity

  def initialize(activity)
    @activity = activity
  end

  def call
    case activity.downcase.to_sym
    when :walk
      rand(0.0012..0.0014)
    when :jog, :trot
      rand(0.0045..0.0056)
    when :canter
      rand(0.0112..0.0137)
    when :gallop
      rand(0.022..0.027)
    when :breeze
      rand(0.0337..0.0412)
    else
      raise ArgumentError, "Unrecognized activity: #{activity}"
    end
  end
end

