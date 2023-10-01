require "rails_helper"

RSpec.describe Account::StablesQuery do
  subject(:query) { described_class.new }

  describe ".active" do
    it "returns stables for active users" do
      stable1 = create(:stable, user: build(:user, :active))
      stable2 = create(:stable, user: build(:user, :pending))
      stable3 = create(:stable, user: build(:user, :banned))
      stable4 = create(:stable, user: build(:user, :deleted))

      result = query.active
      expect(result).to include stable1
      expect(result).not_to include stable2, stable3, stable4
    end
  end

  describe ".ordered_by_name" do
    it "returns stables in ascending order" do
      expect(query.ordered_by_name).to eq(Account::Stable.order(name: :asc))
    end
  end

  describe ".name_includes" do
    it "returns matching stables" do
      stable1 = create(:stable, name: "Foo Stables")
      stable2 = create(:stable, name: "Best Foo Farm")
      stable3 = create(:stable, name: "Bar Stables")

      result = query.name_includes("foo")
      expect(result).to include(stable1, stable2)
      expect(result).not_to include stable3
    end
  end
end

