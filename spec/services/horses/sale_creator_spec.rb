RSpec.describe Horses::SaleCreator do
  context "when horse has no sale offer" do
    it "does not create sale" do
      expect do
        result = described_class.new.accept_offer(horse:, stable:)
        expect(result.created?).to be false
      end.not_to change(Horses::Sale, :count)
    end

    it "returns error" do
      result = described_class.new.accept_offer(horse:, stable:)
      expect(result.error).to eq t("services.sale_creator.not_for_sale")
    end
  end

  context "when buyer cannot afford purchase price" do
    before do
      stable.update(total_balance: 5_000, available_balance: 5_000)
      sale_offer
    end

    it "does not create sale" do
      expect do
        result = described_class.new.accept_offer(horse:, stable:)
        expect(result.created?).to be false
      end.not_to change(Horses::Sale, :count)
    end

    it "returns error" do
      result = described_class.new.accept_offer(horse:, stable:)
      expect(result.error).to eq t("services.sale_creator.cannot_afford_purchase")
    end
  end

  context "when leaser can afford lease fee" do
    before do
      stable.update(total_balance: 50_000, available_balance: 50_000)
      sale_offer
    end

    it "creates sale" do
      expect do
        result = described_class.new.accept_offer(horse:, stable:)
        expect(result.created?).to be true
      end.to change(Horses::Sale, :count).by(1)
    end

    it "returns no error" do
      result = described_class.new.accept_offer(horse:, stable:)
      expect(result.error).to be_nil
    end

    it "creates budget transactions" do
      expect do
        described_class.new.accept_offer(horse:, stable:)
      end.to change(Account::Budget, :count).by(2)
    end

    it "creates notification" do
      expect do
        described_class.new.accept_offer(horse:, stable:)
      end.to change(::SaleAcceptanceNotification, :count).by(1)
    end
  end

  private

  def sale_offer
    @sale_offer ||= create(:sale_offer, horse:, buyer: stable, price: 10_000)
  end

  def horse
    @horse ||= create(:horse)
  end

  def stable
    @stable ||= create(:stable)
  end
end

