RSpec.describe Horses::LeaseOfferCreator do
  context "when params are valid" do
    it "saves lease offer" do
      expect do
        result = described_class.new.create_offer(horse:, params:)
        expect(result.created?).to be true
      end.to change(Horses::LeaseOffer, :count).by(1)
    end

    context "when leaser is set" do
      it "creates notification for leaser if offer has started" do
        leaser = create(:stable)
        new_params = params.dup.merge(offer_start_date: Date.current, leaser_id: leaser.id)
        expect do
          described_class.new.create_offer(horse:, params: new_params)
        end.to change(::LeaseOfferNotification, :count).by(1)
      end

      it "does not create notification for leaser if offer has not started" do
        leaser = create(:stable)
        new_params = params.dup.merge(leaser_id: leaser.id)
        expect do
          described_class.new.create_offer(horse:, params: new_params)
        end.not_to change(::LeaseOfferNotification, :count)
      end
    end
  end

  private

  def params
    {
      offer_start_date: 1.day.from_now,
      duration_months: 6,
      leaser_id: nil,
      member_type: "new_members_only",
      fee: 10_000
    }
  end

  def horse
    @horse ||= create(:horse)
  end
end

#  duration_months  :integer          not null
#  fee              :integer          default(0), not null
#  new_members_only :boolean          default(FALSE), not null
#  offer_start_date :date             not null, indexed
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  horse_id         :bigint           not null, uniquely indexed
#  leaser_id        :bigint           indexed
#  owner_id         :bigint           not null, indexed

