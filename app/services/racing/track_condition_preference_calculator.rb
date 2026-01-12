class Racing::TrackConditionPreferenceCalculator
  attr_reader :track_condition, :fast, :good, :wet, :slow

  def initialize(track_condition:, fast:, good:, wet:, slow:)
    @track_condition = track_condition
    @fast = fast
    @good = good
    @wet = wet
    @slow = slow
  end

  def call
    value = send(track_condition.to_s.downcase)

    (100 - (5 - value)).fdiv(100)
  end
end

