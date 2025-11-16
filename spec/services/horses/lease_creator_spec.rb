RSpec.describe Horses::LeaseCreator do
  context "when horse has no lease offer" do
    it "does not create lease" do
      expect do
        result = described_class.new.accept_offer(horse:, stable:)
        expect(result.created?).to be false
      end.not_to change(Horses::Lease, :count)
    end

    it "returns error" do
      result = described_class.new.accept_offer(horse:, stable:)
      expect(result.error).to eq t("services.lease_creator.not_for_lease")
    end
  end

  context "when leaser cannot afford lease fee" do
    before do
      stable.update(total_balance: 5_000, available_balance: 5_000)
      lease_offer
    end

    it "does not create lease" do
      expect do
        result = described_class.new.accept_offer(horse:, stable:)
        expect(result.created?).to be false
      end.not_to change(Horses::Lease, :count)
    end

    it "returns error" do
      result = described_class.new.accept_offer(horse:, stable:)
      expect(result.error).to eq t("services.lease_creator.cannot_afford_lease")
    end
  end

  context "when leaser cann afford lease fee" do
    before do
      stable.update(total_balance: 50_000, available_balance: 50_000)
      lease_offer
    end

    it "creates lease" do
      expect do
        result = described_class.new.accept_offer(horse:, stable:)
        expect(result.created?).to be true
      end.to change(Horses::Lease, :count).by(1)
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
      end.to change(::LeaseAcceptanceNotification, :count).by(1)
    end
  end

  private

  def lease_offer
    @leaser_offer ||= create(:lease_offer, horse:, leaser: stable, fee: 10_000)
  end

  def horse
    @horse ||= create(:horse)
  end

  def stable
    @stable ||= create(:stable)
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

