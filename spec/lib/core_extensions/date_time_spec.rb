require "spec_helper"

# rubocop:disable RSpec/MultipleExpectations
RSpec.describe DateTime do
  before do
    described_class.prepend(CoreExtensions::DateTime::ParseSafely)
  end

  it "parses date safely" do
    expect(described_class.parse_safely("2017-01-01 13:00")).to eq(described_class.parse("2017-01-01 13:00"))
    expect(described_class.parse_safely("abc")).to be_nil
    expect(described_class.parse_safely(nil)).to be_nil
    expect(described_class.parse_safely(1)).to be_nil
    expect(described_class.parse_safely(Time.now.utc.to_s)).to eq(described_class.parse(Time.now.utc.to_s))
  end
end
# rubocop:enable RSpec/MultipleExpectations

