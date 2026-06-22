RSpec.describe Auction do
  describe "associations" do
    it { is_expected.to belong_to(:auctioneer).class_name("Account::Stable") }
    it { is_expected.to have_many(:horses).class_name("Auctions::Horse").dependent(:destroy) }
    it { is_expected.to have_many(:bids).class_name("Auctions::Bid").dependent(:delete_all) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :start_time }
    it { is_expected.to validate_presence_of :end_time }
    it { is_expected.to validate_presence_of :hours_until_sold }
    it { is_expected.to validate_numericality_of(:horse_purchase_cap_per_stable).only_integer.is_greater_than(0).allow_nil }
    it { is_expected.to validate_numericality_of(:hours_until_sold).only_integer.is_greater_than_or_equal_to(12).is_less_than_or_equal_to(48).allow_nil }
    it { is_expected.to validate_numericality_of(:spending_cap_per_stable).only_integer.is_greater_than_or_equal_to(10_000).allow_nil }

    describe "start time" do
      it "must be more than minimum delay days away" do
        auction = build(:auction, start_time: Date.current)

        expect(auction).not_to be_valid
        expect(auction.errors[:start_time].size).to eq 1
        expect(auction.errors[:start_time].first).to include "must be greater than or equal to #{(Date.current + Config::Auctions.minimum_duration_days.days).to_date}"
        auction.start_time = Date.current + Config::Auctions.minimum_duration_days.days
        expect(auction).to be_valid
      end
    end

    describe "end time" do
      it "must be more than minimum duration days away" do
        auction = build(:auction)
        start_time = auction.start_time
        auction.end_time = start_time + 1.day

        expect(auction).not_to be_valid
        expect(auction.errors[:end_time].size).to eq 1
        expect(auction.errors[:end_time].first).to include "must be greater than or equal to #{(start_time.to_date + Config::Auctions.minimum_duration_days.days).to_date}"
        auction.end_time = start_time + Config::Auctions.minimum_duration_days.days
        expect(auction).to be_valid
      end

      it "must be less than maximum duration days away" do
        auction = build(:auction)
        start_time = auction.start_time
        auction.end_time = start_time + (Config::Auctions.maximum_duration_days + 1).days

        expect(auction).not_to be_valid
        expect(auction.errors[:end_time].size).to eq 1
        expect(auction.errors[:end_time].first).to include "must be less than or equal to #{(start_time.to_date + Config::Auctions.maximum_duration_days.days).to_date}"
        auction.end_time = start_time + Config::Auctions.maximum_duration_days.days
        expect(auction).to be_valid
      end
    end

    describe "status" do
      it "requires at least one status to be picked" do
        auction = build(:auction)
        auction.broodmare_allowed = false
        auction.racehorse_allowed_2yo = false
        auction.racehorse_allowed_3yo = false
        auction.racehorse_allowed_older = false
        auction.stallion_allowed = false
        auction.weanling_allowed = false
        auction.yearling_allowed = false

        expect(auction).not_to be_valid
        expect(auction.errors[:base]).to eq([t("activerecord.errors.models.auction.attributes.base.status_required")])
      end
    end

    describe "auctioneer" do
      context "when auction is auto created" do
        it "cannot be blank" do
          auction = build(:auction, auctioneer: nil)
          expect(auction.valid?(:auto_create)).to be false
          expect(auction.errors[:auctioneer]).to eq ["must exist"]
        end

        it "must be FF" do
          auctioneer = build(:stable, name: "Final Furlong")
          auction = build(:auction, auctioneer:)
          expect(auction.valid?(:auto_create)).to be true
        end

        it "must not be non-FF" do
          auctioneer = build(:stable, name: "Other Stable")
          auction = build(:auction, auctioneer:)
          expect(auction.valid?(:auto_create)).to be false
          expect(auction.errors[:auctioneer]).to eq ["is invalid"]
        end
      end

      context "when auction is not auto created" do
        it "can be non-FF" do
          auctioneer = build(:stable, name: "Final Furlong")
          auction = build(:auction, auctioneer:)
          expect(auction.valid?).to be true
        end

        it "can be FF" do
          auctioneer = build(:stable, name: "Other Stable")
          auction = build(:auction, auctioneer:)
          expect(auction.valid?).to be true
        end
      end
    end
  end

  describe "#active?" do
    context "when current date is between start/end times" do
      it "returns true" do
        auction = create(:auction, :current)
        expect(auction.active?).to be true
      end
    end

    context "when start date is in the future" do
      it "returns false" do
        auction = build(:auction)
        expect(auction.active?).to be false
      end
    end

    context "when end date is in the past" do
      it "returns false" do
        auction = create(:auction, :past)
        expect(auction.active?).to be false
      end
    end
  end

  describe "#ended?" do
    context "when current date before end time" do
      it "returns false" do
        auction = create(:auction, :current)
        expect(auction.ended?).to be false
      end
    end

    context "when current date is equal to end time" do
      it "returns true" do
        auction = build(:auction)
        travel_to auction.end_time do
          expect(auction.ended?).to be true
        end
      end
    end

    context "when current date is end time + 1 day" do
      it "returns true" do
        auction = create(:auction, :past)
        travel_to auction.end_time + 23.hours do
          expect(auction.ended?).to be true
        end
      end
    end

    context "when current date is end time + 2 days" do
      it "returns true" do
        auction = build(:auction)
        travel_to auction.end_time + 2.days do
          expect(auction.ended?).to be true
        end
      end
    end
  end

  describe "#future?" do
    context "when current date is before start time" do
      it "returns true" do
        auction = build(:auction)
        expect(auction.future?).to be true
      end
    end

    context "when current date is after start time" do
      it "returns false" do
        auction = build(:auction)
        travel_to auction.start_time + 1.day do
          expect(auction.future?).to be false
        end
      end
    end
  end

  private

  def global_id_string(object)
    object.to_global_id.to_s
  end
end

