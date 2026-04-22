RSpec.describe Auctions::HorseConsigner do
  context "when auction is not in the future" do
    let(:auction) { past_auction }

    it "returns created false" do
      result = described_class.new.consign_horses(auction:)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.consign_horses(auction:)
      expect(result.error).to eq error("auction_not_future")
    end

    it "does not consign horses" do
      expect do
        result = described_class.new.consign_horses(auction:)
        expect(result.auction).to eq past_auction
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when auction is currently live" do
    let(:auction) { current_auction }

    it "returns created false" do
      result = described_class.new.consign_horses(auction:)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.consign_horses(auction:)
      expect(result.error).to eq error("auction_not_future")
    end

    it "does not consign horses" do
      expect do
        result = described_class.new.consign_horses(auction:)
        expect(result.auction).to eq current_auction
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when auctioneer is not Final Furlong" do
    before { stable.update(name: "Random Stable") }

    it "returns created false" do
      result = described_class.new.consign_horses(auction:)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.consign_horses(auction:)
      expect(result.error).to eq error("non_game_auction")
    end

    it "does not consign horses" do
      expect do
        result = described_class.new.consign_horses(auction:)
        expect(result.auction).to eq auction
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when there are no configs for the auction" do
    it "returns created false" do
      result = described_class.new.consign_horses(auction:)
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.consign_horses(auction:)
      expect(result.error).to eq error("no_consignment_configs")
    end

    it "does not consign horses" do
      expect do
        result = described_class.new.consign_horses(auction:)
        expect(result.auction).to eq auction
      end.not_to change(Auctions::Horse, :count)
    end
  end

  context "when config specifies racehorses" do
    before do
      racehorse_config
      Horses::Horse.destroy_all
    end

    it "returns created true" do
      create(:horse, :final_furlong)
      create_views
      result = described_class.new.consign_horses(auction:)
      expect(result.created?).to be true
    end

    it "returns no error" do
      create(:horse, :final_furlong)
      create_views
      result = described_class.new.consign_horses(auction:)
      expect(result.error).to be_nil
    end
  end

  context "when config specifies stallions" do
    before do
      stallion_config
    end

    it "returns created true" do
      result = described_class.new.consign_horses(auction:)
      expect(result.created?).to be true
    end

    it "returns no error" do
      result = described_class.new.consign_horses(auction:)
      expect(result.error).to be_nil
    end
  end

  context "when config specifies broodmares" do
    before do
      broodmare_config
    end

    it "returns created true" do
      result = described_class.new.consign_horses(auction:)
      expect(result.created?).to be true
    end

    it "returns no error" do
      result = described_class.new.consign_horses(auction:)
      expect(result.error).to be_nil
    end
  end

  context "when config specifies yearlings" do
    before do
      yearling_config
      create_views
    end

    it "returns created true" do
      result = described_class.new.consign_horses(auction:)
      expect(result.created?).to be true
    end

    it "returns no error" do
      result = described_class.new.consign_horses(auction:)
      expect(result.error).to be_nil
    end
  end

  context "when config specifies weanlings" do
    before do
      weanling_config
      create_views
    end

    it "returns created true" do
      result = described_class.new.consign_horses(auction:)
      expect(result.created?).to be true
    end

    it "returns no error" do
      result = described_class.new.consign_horses(auction:)
      expect(result.error).to be_nil
    end
  end

  private

  def error(key)
    I18n.t("services.auctions.horse_consigner.#{key}")
  end

  def stable
    @stable ||= create(:stable, name: "Final Furlong")
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

  def create_views
    Racing::RaceRecord.refresh
    Racing::AnnualRaceRecord.refresh
    Racing::LifetimeRaceRecord.refresh
  end
end

