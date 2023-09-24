require "rails_helper"

RSpec.describe Account::ActivationQuery do
  subject(:query) { described_class.new }

  describe ".activated" do
    it "returns activated users" do
      activated = create(:activation, :activated)
      unactivated = create(:activation, :unactivated)

      result = query.activated
      expect(result).to include activated
      expect(result).not_to include unactivated
    end
  end

  describe ".unactivated" do
    it "returns un-activated users" do
      unactivated = create(:activation, :unactivated)
      activated = create(:activation, :activated)

      result = query.unactivated
      expect(result).to include unactivated
      expect(result).not_to include activated
    end
  end
end

