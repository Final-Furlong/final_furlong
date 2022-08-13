require "rails_helper"

RSpec.describe StablesRepository do
  describe "#active" do
    it "returns stables for active users" do
      stable1 = create(:stable, user: build(:user, :active))
      stable2 = create(:stable, user: build(:user, :pending))
      stable3 = create(:stable, user: build(:user, :banned))
      stable4 = create(:stable, user: build(:user, :deleted))

      result = described_class.new(model: Stable).active
      expect(result).to include stable1
      expect(result).not_to include stable2, stable3, stable4
    end
  end

  describe "#ordered_by_name" do
    it "returns stables in ascending order" do
      expect(described_class.new(model: Stable).ordered_by_name).to eq(Stable.order(name: :asc))
    end
  end
end

