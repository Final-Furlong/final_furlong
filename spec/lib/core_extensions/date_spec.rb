require "spec_helper"

# rubocop:disable RSpec/MultipleExpectations
RSpec.describe Date do
  before do
    described_class.prepend(CoreExtensions::Date::ParseSafely)
    described_class.prepend(CoreExtensions::Date::StrptimeSafely)
  end

  it "parses date safely" do
    expect(described_class.parse_safely("2017-01-01")).to eq(described_class.parse("2017-01-01"))
    expect(described_class.parse_safely("abc")).to be_nil
    expect(described_class.parse_safely(nil)).to be_nil
    expect(described_class.parse_safely(1)).to be_nil
    expect(described_class.parse_safely(Time.zone.today)).to eq Time.zone.today
  end

  it "strptime date safely" do
    expect(described_class.strptime_safely("2108-2017", "%d%m-%Y")).to eq described_class.parse("2017-08-21")
    expect(described_class.strptime_safely("abc", "%d%m-%Y")).to be_nil
    expect(described_class.strptime_safely(nil, "%d%m-%Y")).to be_nil
    expect(described_class.strptime_safely(1, "%d%m-%Y")).to be_nil
  end
end
# rubocop:enable RSpec/MultipleExpectations

