RSpec.describe Racing::ConsistencyCalculator do
  describe "#call" do
    it "is correct" do
      10.times do |n|
        consistency = n + 1
        20.times do
          calculator = described_class.new(consistency:)
          min_value = (100 - 10 - consistency).fdiv(100)
          max_value = (100 - 0 - consistency).fdiv(100)
          expect(calculator.call).to be_between(min_value, max_value)
        end
      end
    end
  end
end

