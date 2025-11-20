RSpec.describe Horses::SaleOfferCreator do
  context "when params are valid" do
    it "saves sale offer" do
      expect do
        result = described_class.new.create_offer(horse:, params:)
        expect(result.created?).to be true
      end.to change(Horses::SaleOffer, :count).by(1)
    end

    context "when buyer is set" do
      it "creates notification for buyer if offer has started" do
        buyer = create(:stable)
        new_params = params.dup.merge(offer_start_date: Date.current, buyer_id: buyer.id)
        expect do
          described_class.new.create_offer(horse:, params: new_params)
        end.to change(::SaleOfferNotification, :count).by(1)
      end

      it "does not create notification for buyer if offer has not started" do
        buyer = create(:stable)
        new_params = params.dup.merge(buyer_id: buyer.id)
        expect do
          described_class.new.create_offer(horse:, params: new_params)
        end.not_to change(::SaleOfferNotification, :count)
      end
    end
  end

  private

  def params
    {
      offer_start_date: 1.day.from_now,
      buyer_id: nil,
      member_type: "new_members_only",
      price: 10_000
    }
  end

  def horse
    @horse ||= create(:horse)
  end
end

