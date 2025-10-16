RSpec.describe Auctions::HorseCreator do
  context "when auction is not found" do
    it "returns created false" do
      result = described_class.new.create_horse(params.merge(auction_id: SecureRandom.uuid))
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params.merge(auction_id: SecureRandom.uuid))
      expect(result.error).to eq error("auction_not_found")
    end

    it "does not consign horses" do
      expect do
        result = described_class.new.create_horse(params.merge(auction_id: SecureRandom.uuid))
        expect(result.auction).to be_nil
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when auction is not in the future" do
    let(:auction) { past_auction }

    it "returns created false" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to eq error("auction_not_future")
    end

    it "does not consign horses" do
      expect do
        result = described_class.new.create_horse(params)
        expect(result.auction).to eq past_auction
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when auction is currently live" do
    let(:auction) { current_auction }

    it "returns created false" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to eq error("auction_not_future")
    end

    it "does not consign horses" do
      expect do
        result = described_class.new.create_horse(params)
        expect(result.auction).to eq current_auction
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when horse cannot be found" do
    it "returns created false" do
      result = described_class.new.create_horse(params.merge(horse_id: SecureRandom.uuid))
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params.merge(horse_id: SecureRandom.uuid))
      expect(result.error).to eq error("horse_not_found")
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params.merge(horse_id: SecureRandom.uuid))
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when stable cannot be found" do
    it "returns created false" do
      result = described_class.new.create_horse(params.merge(stable_id: SecureRandom.uuid))
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params.merge(stable_id: SecureRandom.uuid))
      expect(result.error).to eq error("stable_not_found")
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params.merge(stable_id: SecureRandom.uuid))
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when horse is not owned by stable" do
    before { horse.update(owner: create(:stable)) }

    it "returns created false" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to eq error("horse_not_owned")
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params)
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when horse is not owned by auctioneer" do
    context "when outside horses are not allowed" do
      before { auction.update(outside_horses_allowed: false, auctioneer: create(:stable)) }

      it "returns created false" do
        result = described_class.new.create_horse(params)
        expect(result.created?).to be false
      end

      it "returns error" do
        result = described_class.new.create_horse(params)
        expect(result.error).to eq error("outside_horses_not_allowed")
      end

      it "does not consign horses" do
        expect do
          described_class.new.create_horse(params)
        end.not_to change(Auctions::Horse, :count)
      end
    end

    context "when outside horses are allowed" do
      before { auction.update(outside_horses_allowed: true, auctioneer: create(:stable)) }

      it "returns created true" do
        result = described_class.new.create_horse(params)
        expect(result.created?).to be true
      end

      it "returns no error" do
        result = described_class.new.create_horse(params)
        expect(result.error).to be_nil
      end

      it "consigns horses" do
        expect do
          described_class.new.create_horse(params)
        end.to change(Auctions::Horse, :count).by(1)
      end
    end
  end

  context "when horse is owned by auctioneer" do
    before { auction.update(outside_horses_allowed: false) }

    it "returns created true" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be true
    end

    it "returns error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to be_nil
    end

    it "consigns horses" do
      expect do
        described_class.new.create_horse(params)
      end.to change(Auctions::Horse, :count).by(1)
    end
  end

  context "when horse is dead" do
    before { horse.update(date_of_death: 1.year.ago) }

    it "returns created false" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to eq error("dead_horses_not_allowed")
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params)
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when horse is unborn" do
    before { horse.update(date_of_birth: 1.year.from_now, status: "unborn") }

    it "returns created false" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to eq error("unborn_horses_not_allowed")
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params)
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when broodmares are not allowed and horse is broodmare" do
    before do
      auction.update(broodmare_allowed: false)
      horse.update(status: "broodmare")
    end

    it "returns created false" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to eq error("broodmares_not_allowed")
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params)
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when stallions are not allowed and horse is stallion" do
    before do
      auction.update(stallion_allowed: false)
      horse.update(status: "stud")
    end

    it "returns created false" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to eq error("stallions_not_allowed")
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params)
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when 2yos are not allowed and horse is 2yo" do
    before do
      auction.update(racehorse_allowed_2yo: false)
      horse.update(status: "racehorse", date_of_birth: 2.years.ago)
    end

    it "returns created false" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to eq error("racehorse_2yo_not_allowed")
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params)
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when 3yos are not allowed and horse is 3yo" do
    before do
      auction.update(racehorse_allowed_3yo: false)
      horse.update(status: "racehorse", date_of_birth: 3.years.ago)
    end

    it "returns created false" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to eq error("racehorse_3yo_not_allowed")
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params)
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when older racehorses are not allowed and horse is 4yo+" do
    before do
      auction.update(racehorse_allowed_older: false)
      horse.update(status: "racehorse", date_of_birth: 5.years.ago)
    end

    it "returns created false" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to eq error("racehorse_older_not_allowed")
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params)
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when yearlings are not allowed and horse is yearling" do
    before do
      auction.update(yearling_allowed: false)
      horse.update(status: "yearling", date_of_birth: 1.year.ago)
    end

    it "returns created false" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to eq error("yearlings_not_allowed")
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params)
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when weanlings are not allowed and horse is weanling" do
    before do
      auction.update(weanling_allowed: false)
      horse.update(status: "weanling", date_of_birth: 1.day.ago)
    end

    it "returns created false" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to eq error("weanlings_not_allowed")
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params)
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when reserve pricing is not allowed and reserve price is set" do
    before { auction.update(reserve_pricing_allowed: false) }

    it "returns created false" do
      result = described_class.new.create_horse(params.merge(reserve_price: 10_000))
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_horse(params.merge(reserve_price: 10_000))
      expect(result.error).to eq error("reserves_not_allowed")
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params.merge(reserve_price: 10_000))
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when reserve pricing is allowed and reserve price is set" do
    before do
      auction.update(reserve_pricing_allowed: true)
      Accounts::BudgetTransactionCreator.new.create_transaction(stable:, description: "Opening Balance", amount: 50_000)
    end

    it "returns created true" do
      result = described_class.new.create_horse(params.merge(reserve_price: 10_000))
      expect(result.created?).to be true
    end

    it "returns no error" do
      result = described_class.new.create_horse(params.merge(reserve_price: 10_000))
      expect(result.error).to be_nil
    end

    it "consigns horses" do
      expect do
        described_class.new.create_horse(params.merge(reserve_price: 10_000))
      end.to change(Auctions::Horse, :count).by(1)
      expect(Auctions::Horse.last.reserve_price).to eq 10_000
    end

    it "charges fee of 10% of reserve price" do
      expect do
        described_class.new.create_horse(params.merge(reserve_price: 10_000))
      end.to change(Account::Budget, :count).by(1)
      expect(Account::Budget.recent.first.amount).to eq(-1_000)
    end

    context "when stable cannot afford fee" do
      before do
        stable.update(available_balance: 2_000, total_balance: 2_000)
      end

      it "does not charge 10% fee" do
        expect do
          described_class.new.create_horse(params.merge(reserve_price: 50_000))
        end.not_to change(Account::Budget, :count)
      end

      it "does not consign horse" do
        expect do
          described_class.new.create_horse(params.merge(reserve_price: 50_000))
        end.not_to change(Auctions::Horse, :count)
      end
    end
  end

  context "when comment is set" do
    it "returns created true" do
      result = described_class.new.create_horse(params.merge(comment:))
      expect(result.created?).to be true
    end

    it "returns no error" do
      result = described_class.new.create_horse(params.merge(comment:))
      expect(result.error).to be_nil
    end

    it "consigns horses" do
      expect do
        described_class.new.create_horse(params.merge(comment:))
      end.to change(Auctions::Horse, :count).by(1)
      expect(Auctions::Horse.last.comment).to eq comment
    end
  end

  context "when spending cap exists for auction" do
    before { auction.update(spending_cap_per_stable: 100_000) }

    it "returns created true" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be true
    end

    it "returns no error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to be_nil
    end

    it "consigns horses" do
      expect do
        described_class.new.create_horse(params)
      end.to change(Auctions::Horse, :count).by(1)
      expect(Auctions::Horse.last.maximum_price).to eq 100_000
    end
  end

  context "when creating horse fails" do
    before { create(:auction_horse, horse:) }

    it "returns created false" do
      result = described_class.new.create_horse(params)
      expect(result.created?).to be false
    end

    it "returns no error" do
      result = described_class.new.create_horse(params)
      expect(result.error).to eq "Validation failed: Horse is already consigned to an auction"
    end

    it "does not consign horses" do
      expect do
        described_class.new.create_horse(params)
      end.not_to change(Auctions::Horse, :count)
    end
  end

  private

  def error(key)
    I18n.t("services.auctions.horse_creator.#{key}")
  end

  def comment
    @comment ||= SecureRandom.alphanumeric(20)
  end

  def params
    {
      auction_id: auction.id,
      horse_id: horse.id,
      stable_id: stable.id
    }
  end

  def horse
    @horse ||= create(:horse, owner: stable)
  end

  def stable
    @stable ||= create(:stable, legacy_id: 5)
  end

  def auction
    @auction ||= create(:auction, auctioneer: stable)
  end

  def current_auction
    @current_auction ||= create(:auction, :current, auctioneer: stable)
  end

  def past_auction
    @past_auction ||= create(:auction, :past, auctioneer: stable)
  end

  def racehorse_config
    @racehorse_config ||= Auctions::ConsignmentConfig.create!(
      auction:,
      horse_type: "racehorse",
      minimum_age: 2,
      maximum_age: 4,
      minimum_count: 1
    )
  end

  def stallion_config
    @stallion_config ||= Auctions::ConsignmentConfig.create!(
      auction:,
      horse_type: "stud",
      minimum_age: 4,
      maximum_age: 12,
      minimum_count: 1
    )
  end

  def broodmare_config
    @broodmare_config ||= Auctions::ConsignmentConfig.create!(
      auction:,
      horse_type: "broodmare",
      minimum_age: 4,
      maximum_age: 12,
      minimum_count: 1
    )
  end

  def yearling_config
    @yearling_config ||= Auctions::ConsignmentConfig.create!(
      auction:,
      horse_type: "yearling",
      minimum_age: 1,
      maximum_age: 1,
      minimum_count: 1
    )
  end

  def weanling_config
    @weanling_config ||= Auctions::ConsignmentConfig.create!(
      auction:,
      horse_type: "weanling",
      minimum_age: 0,
      maximum_age: 0,
      minimum_count: 5
    )
  end
end

