RSpec.describe CurrentStable::SaleOfferPolicy do
  subject(:policy) { described_class.new(user, offer) }

  describe "#scope" do
    subject(:scope) { described_class::Scope.new(user, Horses::SaleOffer).resolve }

    it "includes offers for the stable" do
      expect(scope).to eq Horses::SaleOffer.with_owner(stable)
    end
  end

  private

  def user
    @user ||= create(:user)
  end

  def offer
    @offer ||= build(:sale_offer)
  end

  def stable
    @stable ||= user.stable
  end
end

