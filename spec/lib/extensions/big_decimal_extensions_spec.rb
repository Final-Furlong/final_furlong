require "spec_helper"

# rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
RSpec.describe BigDecimal do
  it "divides number to array with remainder" do
    expect(BigDecimal("0").in_instalments(0)).to be_empty
    expect(BigDecimal("0").in_instalments(1)).to be_empty

    expect(BigDecimal("2").in_instalments(1)).to eq([2])

    expect(BigDecimal("2").in_instalments(2)).to eq([1, 1])
    expect(BigDecimal("2").in_instalments(2)).to eq([1, 1])
    expect(BigDecimal("3").in_instalments(2)).to eq([2, 1])
    expect(BigDecimal("7").in_instalments(2)).to eq([4, 3])

    expect(BigDecimal("3").in_instalments(6)).to eq([3])
    expect(BigDecimal("7").in_instalments(6)).to eq([2, 1, 1, 1, 1, 1])
    expect(BigDecimal("12").in_instalments(6)).to eq([2, 2, 2, 2, 2, 2])
    expect(BigDecimal("13").in_instalments(6)).to eq([3, 2, 2, 2, 2, 2])
  end
end
# rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength
