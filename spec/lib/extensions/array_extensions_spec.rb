require "rails_helper"

RSpec.describe Array do
  it "processes empty array" do
    expect([].in_groups_alternately(0)).to be_empty
  end

  it "matches empty array" do
    result = [].in_groups_alternately(1)
    expect(result).to eq([[]])
  end

  it "breaks into two arrays" do
    result = %w[a b c d e].in_groups_alternately(2)

    expect(result).to eq([%w[a c e], %w[b d]])
  end

  it "breaks into five arrays" do
    result = %w[a b c d e].in_groups_alternately(5)

    expect(result).to eq([["a"], ["b"], ["c"], ["d"], ["e"]])
  end

  it "breaks into six arrays" do
    result = %w[a b c d e].in_groups_alternately(6)

    expect(result).to eq([["a"], ["b"], ["c"], ["d"], ["e"], []])
  end
end
