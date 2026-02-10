RSpec.describe Account::ActivationQuery do
  subject(:query) { described_class.new }

  describe "#activated" do
    it "returns activated users" do
      activated = create(:activation, :activated, user: create(:user, :without_stable))
      unactivated = create(:activation, :unactivated, user: create(:user, :without_stable))

      result = query.activated
      expect(result).to include activated
      expect(result).not_to include unactivated
    end
  end

  describe "#unactivated", :stable do
    it "returns un-activated users" do
      activated = create(:activation, :activated, user: create(:user, :without_stable))
      unactivated = create(:activation, :unactivated, user: create(:user, :without_stable))

      result = query.unactivated
      expect(result).to include unactivated
      expect(result).not_to include activated
    end
  end

  describe "#exists_with_token?" do
    context "when token + stable name match" do
      it "returns true" do
        user = create(:user, :unactivated)
        stable = user.stable
        activation = user.activation

        expect(query.exists_with_token?(stable_name: stable.name, token: activation.token)).to be true
      end
    end

    context "when stable name does not match" do
      it "returns false" do
        user = create(:user, :unactivated)
        stable = create(:stable)
        activation = user.activation

        expect(query.exists_with_token?(stable_name: stable.name, token: activation.token)).to be false
      end
    end

    context "when token does not match" do
      it "returns false" do
        user = create(:user, :unactivated)
        stable = user.stable
        activation = create(:activation, user: create(:user, :without_stable))

        expect(query.exists_with_token?(stable_name: stable.name, token: activation.token)).to be false
      end
    end
  end
end

