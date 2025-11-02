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
      Legacy::Horse.destroy_all
    end

    it "returns created true" do
      legacy_racehorse = create(:legacy_horse, :racehorse, :final_furlong, can_be_sold: true)
      create(:horse, owner: stable, legacy_id: legacy_racehorse.ID)
      result = described_class.new.consign_horses(auction:)
      expect(result.created?).to be true
    end

    it "returns no error" do
      legacy_racehorse = create(:legacy_horse, :racehorse, :final_furlong, can_be_sold: true)
      create(:horse, owner: stable, legacy_id: legacy_racehorse.ID)
      result = described_class.new.consign_horses(auction:)
      expect(result.error).to be_nil
    end

    it "deletes config" do
      legacy_racehorse = create(:legacy_horse, :racehorse, :final_furlong, can_be_sold: true)
      create(:horse, owner: stable, legacy_id: legacy_racehorse.ID)
      expect do
        described_class.new.consign_horses(auction:)
      end.to change(Auctions::ConsignmentConfig, :count).by(-1)
    end

    it "consigns horses" do
      legacy_racehorse = create(:legacy_horse, :racehorse, :final_furlong, can_be_sold: true)
      racehorse = create(:horse, owner: stable, legacy_id: legacy_racehorse.ID)
      expect do
        result = described_class.new.consign_horses(auction:)
        expect(result.number_consigned).to eq 1
      end.to change(Auctions::Horse, :count).by(1)
      expect(Auctions::Horse.last.horse).to eq racehorse
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

    it "deletes config" do
      legacy_stud = create(:legacy_horse, :stallion, :final_furlong, can_be_sold: true)
      create(:horse, owner: stable, legacy_id: legacy_stud.ID)
      expect do
        described_class.new.consign_horses(auction:)
      end.to change(Auctions::ConsignmentConfig, :count).by(-1)
    end

    it "consigns horses" do
      legacy_stud = create(:legacy_horse, :stallion, :final_furlong, can_be_sold: true)
      stallion = create(:horse, owner: stable, legacy_id: legacy_stud.ID)
      expect do
        result = described_class.new.consign_horses(auction:)
        expect(result.number_consigned).to eq 1
      end.to change(Auctions::Horse, :count).by(1)
      expect(Auctions::Horse.last.horse).to eq stallion
    end

    context "when consigned horses already exist" do
      it "does not consign horses" do
        legacy_stud = create(:legacy_horse, :stallion, :final_furlong, can_be_sold: true)
        stallion = create(:horse, :stallion, owner: stable, legacy_id: legacy_stud.ID)
        create(:auction_horse, horse: stallion, auction:)
        expect do
          result = described_class.new.consign_horses(auction:)
          expect(result.number_consigned).to eq 1
        end.not_to change(Auctions::Horse, :count)
        expect(Auctions::Horse.last.horse).to eq stallion
      end
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

    it "deletes config" do
      legacy_mare = create(:legacy_horse, :broodmare, :final_furlong, can_be_sold: true)
      create(:horse, owner: stable, legacy_id: legacy_mare.ID)
      expect do
        described_class.new.consign_horses(auction:)
      end.to change(Auctions::ConsignmentConfig, :count).by(-1)
    end

    it "consigns horses" do
      legacy_mare = create(:legacy_horse, :broodmare, :final_furlong, can_be_sold: true)
      broodmare = create(:horse, owner: stable, legacy_id: legacy_mare.ID)
      expect do
        result = described_class.new.consign_horses(auction:)
        expect(result.number_consigned).to eq 1
      end.to change(Auctions::Horse, :count).by(1)
      expect(Auctions::Horse.last.horse).to eq broodmare
    end
  end

  context "when config specifies yearlings" do
    before do
      yearling_config
    end

    it "returns created true" do
      result = described_class.new.consign_horses(auction:)
      expect(result.created?).to be true
    end

    it "returns no error" do
      result = described_class.new.consign_horses(auction:)
      expect(result.error).to be_nil
    end

    it "deletes config" do
      legacy_foal = create(:legacy_horse, :yearling, :final_furlong, can_be_sold: true)
      create(:horse, owner: stable, legacy_id: legacy_foal.ID)
      expect do
        described_class.new.consign_horses(auction:)
      end.to change(Auctions::ConsignmentConfig, :count).by(-1)
    end

    it "consigns horses" do
      legacy_foal = create(:legacy_horse, :yearling, :final_furlong, can_be_sold: true)
      foal = create(:horse, owner: stable, legacy_id: legacy_foal.ID)
      expect do
        result = described_class.new.consign_horses(auction:)
        expect(result.number_consigned).to eq 1
      end.to change(Auctions::Horse, :count).by(1)
      expect(Auctions::Horse.last.horse).to eq foal
    end
  end

  context "when config specifies weanlings" do
    before do
      weanling_config
    end

    it "returns created true" do
      result = described_class.new.consign_horses(auction:)
      expect(result.created?).to be true
    end

    it "returns no error" do
      result = described_class.new.consign_horses(auction:)
      expect(result.error).to be_nil
    end

    it "does not delete config" do
      legacy_foal = create(:legacy_horse, :weanling, :final_furlong, can_be_sold: true)
      create(:horse, owner: stable, legacy_id: legacy_foal.ID)
      expect do
        described_class.new.consign_horses(auction:)
      end.not_to change(Auctions::ConsignmentConfig, :count)
    end

    it "consigns horses" do
      legacy_foal = create(:legacy_horse, :weanling, :final_furlong, can_be_sold: true)
      foal = create(:horse, owner: stable, legacy_id: legacy_foal.ID)
      expect do
        result = described_class.new.consign_horses(auction:)
        expect(result.number_consigned).to eq 1
      end.to change(Auctions::Horse, :count).by(1)
      expect(Auctions::Horse.last.horse).to eq foal
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
end

