# $maxweight = $horse['Weight'] * 0.9;
# $weight = $horse['JWeight'];
# $pctCarried = 1 + (0.9 - $weight / $maxweight);
class Workouts::WeightCarriedCalculator
  attr_reader :weight, :max_weight

  def initialize(weight, max_weight)
    @weight = weight * 0.9
    @max_weight = max_weight
  end

  def call
    1 + (0.9 - weight.fdiv(max_weight))
  end
end

