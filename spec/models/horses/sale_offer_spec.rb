RSpec.describe Horses::SaleOffer do
  describe "associations" do
    subject(:offer) { build_stubbed(:sale_offer) }

    it { is_expected.to belong_to(:horse).class_name("Horses::Horse") }
    it { is_expected.to belong_to(:owner).class_name("Account::Stable") }
    it { is_expected.to belong_to(:buyer).class_name("Account::Stable").optional }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:offer_start_date) }
    it { is_expected.to validate_presence_of(:price) }

    describe "new members" do
      context "when buyer is set" do
        it "cannot be true" do
          offer = build_stubbed(:sale_offer, buyer: build_stubbed(:stable))
          offer.new_members_only = true
          expect(offer).not_to be_valid
          expect(offer.errors[:new_members_only]).to eq(["cannot be selected when you have picked a specific stable"])
        end

        it "can be false" do
          offer = build_stubbed(:sale_offer, buyer: build_stubbed(:stable))
          offer.new_members_only = false
          expect(offer).to be_valid
        end
      end
    end

    describe "offer start date" do
      it "cannot be more than the maximum" do
        offer = build_stubbed(:sale_offer, offer_start_date: Date.current + (Config::Sales.max_offer_period + 1).days)
        expect(offer).not_to be_valid
        max_date = Date.current + Config::Sales.max_offer_period.days
        expect(offer.errors[:offer_start_date]).to eq(["must be less than or equal to #{I18n.l(max_date)}"])
      end

      it "cannot be less than the minimum" do
        offer = build_stubbed(:sale_offer, offer_start_date: Date.current - 1.day)
        expect(offer).not_to be_valid
        expect(offer.errors[:offer_start_date]).to eq(["must be greater than or equal to #{I18n.l(Date.current)}"])
      end
    end
  end

  describe "scopes" do
    describe ".active" do
      it "returns correct results" do
        offer1 = create(:sale_offer)
        offer1.update_column(:offer_start_date, 1.day.ago)
        offer2 = create(:sale_offer, offer_start_date: Date.current)
        offer3 = create(:sale_offer, offer_start_date: 1.day.from_now)

        result = described_class.active
        expect(result).to include offer1, offer2
        expect(result).not_to include offer3
      end
    end

    describe ".offered_to" do
      it "returns correct records" do
        buyer = create(:stable)
        offer1 = create(:sale_offer, buyer:)
        offer2 = create(:sale_offer, buyer: nil)
        offer3 = create(:sale_offer, buyer: create(:stable))

        result = described_class.offered_to(buyer)
        expect(result).to include offer1
        expect(result).not_to include offer2, offer3
      end
    end

    describe ".with_owner" do
      it "returns correct records" do
        owner = create(:stable)
        offer1 = create(:sale_offer, owner:)
        offer2 = create(:sale_offer, owner: create(:stable))

        result = described_class.with_owner(owner)
        expect(result).to include offer1
        expect(result).not_to include offer2
      end
    end

    describe ".without_owner" do
      it "returns correct records" do
        owner = create(:stable)
        offer1 = create(:sale_offer, owner: create(:stable))
        offer2 = create(:sale_offer, owner:)

        result = described_class.without_owner(owner)
        expect(result).to include offer1
        expect(result).not_to include offer2
      end
    end

    describe ".new_members_only" do
      it "returns correct records" do
        offer1 = create(:sale_offer, new_members_only: true)
        offer2 = create(:sale_offer, new_members_only: false)

        result = described_class.new_members_only
        expect(result).to include offer1, offer2
      end
    end

    describe ".non_new_members_only" do
      it "returns correct records" do
        offer1 = create(:sale_offer, new_members_only: false)
        offer2 = create(:sale_offer, new_members_only: true)

        result = described_class.non_new_members_only
        expect(result).to include offer1
        expect(result).not_to include offer2
      end
    end

    describe ".valid_for_stable" do
      context "when stable is newbie" do
        it "includes active offers only" do
          stable = create(:stable, created_at: 6.months.ago)
          offer1 = create(:sale_offer, offer_start_date: Date.current, buyer: stable)
          offer2 = create(:sale_offer, offer_start_date: 1.day.from_now, buyer: stable)

          result = described_class.valid_for_stable(stable)
          expect(result).to include offer1
          expect(result).not_to include offer2
        end

        it "includes new member leases and non-new member leases" do
          stable = create(:stable, created_at: 6.months.ago)
          offer1 = create(:sale_offer, buyer: nil, new_members_only: true)
          offer2 = create(:sale_offer, buyer: nil, new_members_only: false)

          result = described_class.valid_for_stable(stable)
          expect(result).to include offer1, offer2
        end

        it "includes offers for this stable" do
          stable = create(:stable, created_at: 6.months.ago)
          offer1 = create(:sale_offer, buyer: stable)
          offer2 = create(:sale_offer, buyer: create(:stable))

          result = described_class.valid_for_stable(stable)
          expect(result).to include offer1
          expect(result).not_to include offer2
        end

        it "excludes offers by this stable" do
          stable = create(:stable, created_at: 6.months.ago)
          offer1 = create(:sale_offer, buyer: stable)
          offer2 = create(:sale_offer, owner: stable)

          result = described_class.valid_for_stable(stable)
          expect(result).to include offer1
          expect(result).not_to include offer2
        end
      end

      context "when stable is not newbie" do
        it "includes active leases only" do
          stable = create(:stable, created_at: 18.months.ago)
          offer1 = create(:sale_offer, offer_start_date: Date.current, buyer: stable)
          offer2 = create(:sale_offer, offer_start_date: 1.day.from_now, buyer: stable)

          result = described_class.valid_for_stable(stable)
          expect(result).to include offer1
          expect(result).not_to include offer2
        end

        it "includes non-new member leases, excludes new member leases" do
          stable = create(:stable, created_at: 18.months.ago)
          offer1 = create(:sale_offer, new_members_only: false)
          offer2 = create(:sale_offer, new_members_only: true)

          result = described_class.valid_for_stable(stable)
          expect(result).to include offer1
          expect(result).not_to include offer2
        end

        it "includes offers for this stable" do
          stable = create(:stable, created_at: 18.months.ago)
          offer1 = create(:sale_offer, buyer: stable)
          offer2 = create(:sale_offer, buyer: create(:stable))

          result = described_class.valid_for_stable(stable)
          expect(result).to include offer1
          expect(result).not_to include offer2
        end

        it "excludes offers by this stable" do
          stable = create(:stable, created_at: 18.months.ago)
          offer1 = create(:sale_offer, buyer: stable)
          offer2 = create(:sale_offer, owner: stable)

          result = described_class.valid_for_stable(stable)
          expect(result).to include offer1
          expect(result).not_to include offer2
        end
      end
    end
  end
end

