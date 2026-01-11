class Racing::ConsistencyCalculator
  attr_reader :consistency

  def initialize(consistency:)
    @consistency = consistency
  end

  def call
    random = rand(0..10)
    (100 - random - consistency).fdiv(100)
  end
end

