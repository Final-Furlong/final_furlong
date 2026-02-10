RSpec.describe Horses::LeaseOffer do
  describe "associations" do
    subject(:offer) { build_stubbed(:lease_offer) }

    it { is_expected.to belong_to(:horse).class_name("Horses::Horse") }
    it { is_expected.to belong_to(:owner).class_name("Account::Stable") }
    it { is_expected.to belong_to(:leaser).class_name("Account::Stable").optional }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:offer_start_date) }
    it { is_expected.to validate_presence_of(:duration_months) }
    it { is_expected.to validate_presence_of(:fee) }

    describe "new members" do
      context "when leaser is set" do
        it "cannot be true" do
          offer = build_stubbed(:lease_offer, leaser: build_stubbed(:stable))
          offer.new_members_only = true
          expect(offer).not_to be_valid
          expect(offer.errors[:new_members_only]).to eq(["cannot be selected when you have picked a specific stable"])
        end

        it "can be false" do
          offer = build_stubbed(:lease_offer, leaser: build_stubbed(:stable))
          offer.new_members_only = false
          expect(offer).to be_valid
        end
      end
    end

    describe "offer start date" do
      it "cannot be more than the maximum" do
        offer = build_stubbed(:lease_offer, offer_start_date: Date.current + (Config::Leases.max_offer_period + 1).days)
        expect(offer).not_to be_valid
        max_date = Date.current + Config::Leases.max_offer_period.days
        expect(offer.errors[:offer_start_date]).to eq(["must be less than or equal to #{I18n.l(max_date)}"])
      end

      context "when horse is racehorse" do
        it "cannot be less than the minimum" do
          offer = build_stubbed(:lease_offer, offer_start_date: Date.current - 1.day, horse: build_stubbed(:horse, :racehorse))
          expect(offer).not_to be_valid
          expect(offer.errors[:offer_start_date]).to eq(["must be greater than or equal to #{I18n.l(Date.current)}"])
        end
      end

      context "when horse is stud" do
        it "cannot be less than the minimum" do
          date = Game::BreedingSeason.next_season_start_date - (Config::Leases.max_offer_period + 1).days
          offer = build_stubbed(:lease_offer, offer_start_date: date, horse: build_stubbed(:horse, :stallion))
          expect(offer).not_to be_valid
          expect(offer.errors[:offer_start_date]).to eq(["must be greater than or equal to #{I18n.l(date + 1.day)}"])
        end
      end

      context "when horse is broodmare" do
        it "cannot be less than the minimum" do
          date = Game::BreedingSeason.next_season_start_date - (Config::Leases.max_offer_period + 1).days
          offer = build_stubbed(:lease_offer, offer_start_date: date, horse: build_stubbed(:horse, :broodmare))
          expect(offer).not_to be_valid
          expect(offer.errors[:offer_start_date]).to eq(["must be greater than or equal to #{I18n.l(date + 1.day)}"])
        end
      end
    end

    describe "duration months" do
      context "when horse is a racehorse" do
        it "can be between 3-12 months" do
          offer = build_stubbed(:lease_offer, offer_start_date: Date.current, horse: build_stubbed(:horse, :racehorse))
          (3...12).each do |n_months|
            offer.duration_months = n_months
            expect(offer).to be_valid
          end
        end

        it "cannot be less than 3" do
          offer = build_stubbed(:lease_offer, offer_start_date: Date.current, horse: build_stubbed(:horse, :racehorse))
          offer.duration_months = 2
          expect(offer).not_to be_valid
          expect(offer.errors[:duration_months]).to eq(["must be greater than or equal to 3"])
        end

        it "cannot be more than 12" do
          offer = build_stubbed(:lease_offer, offer_start_date: Date.current, horse: build_stubbed(:horse, :racehorse))
          offer.duration_months = 13
          expect(offer).not_to be_valid
          expect(offer.errors[:duration_months]).to eq(["must be less than or equal to 12"])
        end
      end

      context "when horse is racehorse" do
        it "cannot be less than the minimum" do
          offer = build_stubbed(:lease_offer, offer_start_date: Date.current - 1.day, horse: build_stubbed(:horse, :racehorse))
          expect(offer).not_to be_valid
          expect(offer.errors[:offer_start_date]).to eq(["must be greater than or equal to #{I18n.l(Date.current)}"])
        end
      end

      context "when horse is stud" do
        it "cannot be less than the minimum" do
          date = Game::BreedingSeason.next_season_start_date - (Config::Leases.max_offer_period + 1).days
          offer = build_stubbed(:lease_offer, offer_start_date: date, horse: build_stubbed(:horse, :stallion))
          expect(offer).not_to be_valid
          expect(offer.errors[:offer_start_date]).to eq(["must be greater than or equal to #{I18n.l(date + 1.day)}"])
        end
      end

      context "when horse is broodmare" do
        it "cannot be less than the minimum" do
          date = Game::BreedingSeason.next_season_start_date - (Config::Leases.max_offer_period + 1).days
          offer = build_stubbed(:lease_offer, offer_start_date: date, horse: build_stubbed(:horse, :broodmare))
          expect(offer).not_to be_valid
          expect(offer.errors[:offer_start_date]).to eq(["must be greater than or equal to #{I18n.l(date + 1.day)}"])
        end
      end
    end
  end

  describe "scopes" do
    describe ".active" do
      it "returns correct results" do
        lease1 = create(:lease_offer)
        lease1.update_column(:offer_start_date, 1.day.ago)
        lease2 = create(:lease_offer, offer_start_date: Date.current)
        lease3 = create(:lease_offer, offer_start_date: 1.day.from_now)

        result = described_class.active
        expect(result).to include lease1, lease2
        expect(result).not_to include lease3
      end
    end

    describe ".leased_to" do
      it "returns correct records" do
        leaser = create(:stable)
        lease1 = create(:lease_offer, leaser:)
        lease2 = create(:lease_offer, leaser: nil)
        lease3 = create(:lease_offer, leaser: create(:stable))

        result = described_class.leased_to(leaser)
        expect(result).to include lease1
        expect(result).not_to include lease2, lease3
      end
    end

    describe ".with_owner" do
      it "returns correct records" do
        owner = create(:stable)
        lease1 = create(:lease_offer, owner:)
        lease2 = create(:lease_offer, owner: create(:stable))

        result = described_class.with_owner(owner)
        expect(result).to include lease1
        expect(result).not_to include lease2
      end
    end

    describe ".without_owner" do
      it "returns correct records" do
        owner = create(:stable)
        lease1 = create(:lease_offer, owner: create(:stable))
        lease2 = create(:lease_offer, owner:)

        result = described_class.without_owner(owner)
        expect(result).to include lease1
        expect(result).not_to include lease2
      end
    end

    describe ".new_members_only" do
      it "returns correct records" do
        lease1 = create(:lease_offer, new_members_only: true)
        lease2 = create(:lease_offer, new_members_only: false)

        result = described_class.new_members_only
        expect(result).to include lease1, lease2
      end
    end

    describe ".non_new_members_only" do
      it "returns correct records" do
        lease1 = create(:lease_offer, new_members_only: false)
        lease2 = create(:lease_offer, new_members_only: true)

        result = described_class.non_new_members_only
        expect(result).to include lease1
        expect(result).not_to include lease2
      end
    end

    describe ".valid_for_stable" do
      context "when stable is newbie" do
        it "includes active leases only" do
          stable = create(:stable, created_at: 6.months.ago)
          lease1 = create(:lease_offer, offer_start_date: Date.current, leaser: stable)
          lease2 = create(:lease_offer, offer_start_date: 1.day.from_now, leaser: stable)

          result = described_class.valid_for_stable(stable)
          expect(result).to include lease1
          expect(result).not_to include lease2
        end

        it "includes new member leases and non-new member leases" do
          stable = create(:stable, created_at: 6.months.ago)
          lease1 = create(:lease_offer, leaser: nil, new_members_only: true)
          lease2 = create(:lease_offer, leaser: nil, new_members_only: false)

          result = described_class.valid_for_stable(stable)
          expect(result).to include lease1, lease2
        end

        it "includes leases for this stable" do
          stable = create(:stable, created_at: 6.months.ago)
          lease1 = create(:lease_offer, leaser: stable)
          lease2 = create(:lease_offer, leaser: create(:stable))

          result = described_class.valid_for_stable(stable)
          expect(result).to include lease1
          expect(result).not_to include lease2
        end

        it "excludes leases by this stable" do
          stable = create(:stable, created_at: 6.months.ago)
          lease1 = create(:lease_offer, leaser: stable)
          lease2 = create(:lease_offer, owner: stable)

          result = described_class.valid_for_stable(stable)
          expect(result).to include lease1
          expect(result).not_to include lease2
        end
      end

      context "when stable is not newbie" do
        it "includes active leases only" do
          stable = create(:stable, created_at: 18.months.ago)
          lease1 = create(:lease_offer, offer_start_date: Date.current, leaser: stable)
          lease2 = create(:lease_offer, offer_start_date: 1.day.from_now, leaser: stable)

          result = described_class.valid_for_stable(stable)
          expect(result).to include lease1
          expect(result).not_to include lease2
        end

        it "includes non-new member leases, excludes new member leases" do
          stable = create(:stable, created_at: 18.months.ago)
          lease1 = create(:lease_offer, new_members_only: false)
          lease2 = create(:lease_offer, new_members_only: true)

          result = described_class.valid_for_stable(stable)
          expect(result).to include lease1
          expect(result).not_to include lease2
        end

        it "includes leases for this stable" do
          stable = create(:stable, created_at: 18.months.ago)
          lease1 = create(:lease_offer, leaser: stable)
          lease2 = create(:lease_offer, leaser: create(:stable))

          result = described_class.valid_for_stable(stable)
          expect(result).to include lease1
          expect(result).not_to include lease2
        end

        it "excludes leases by this stable" do
          stable = create(:stable, created_at: 18.months.ago)
          lease1 = create(:lease_offer, leaser: stable)
          lease2 = create(:lease_offer, owner: stable)

          result = described_class.valid_for_stable(stable)
          expect(result).to include lease1
          expect(result).not_to include lease2
        end
      end
    end
  end
end

