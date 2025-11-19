RSpec.describe Auctions::BidCreator do
  context "when auction cannot be found" do
    it "returns created false" do
      result = described_class.new.create_bid(bid_params.merge(auction_id: SecureRandom.uuid))
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_bid(bid_params.merge(auction_id: SecureRandom.uuid))
      expect(result.error).to eq error("auction_not_found")
    end

    it "does not create bid" do
      expect do
        result = described_class.new.create_bid(bid_params.merge(auction_id: SecureRandom.uuid))
        expect(result.auction).to be_nil
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when auction is not active" do
    it "returns created false" do
      result = described_class.new.create_bid(bid_params.merge(auction_id: past_auction.id))
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_bid(bid_params.merge(auction_id: past_auction.id))
      expect(result.error).to eq "Auction is not active"
    end

    it "does not create bid" do
      expect do
        result = described_class.new.create_bid(bid_params.merge(auction_id: past_auction.id))
        expect(result.auction).to eq past_auction
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when auction horse cannot be found" do
    it "returns created false" do
      result = described_class.new.create_bid(bid_params.merge(horse_id: SecureRandom.uuid))
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_bid(bid_params.merge(horse_id: SecureRandom.uuid))
      expect(result.error).to eq error("horse_not_found")
    end

    it "does not create bid" do
      expect do
        described_class.new.create_bid(bid_params.merge(horse_id: SecureRandom.uuid))
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when auction horse is sold" do
    it "returns created false" do
      horse.update(sold_at: Time.current)
      result = described_class.new.create_bid(bid_params)
      expect(result.created?).to be false
    end

    it "returns error" do
      horse.update(sold_at: Time.current)
      result = described_class.new.create_bid(bid_params)
      expect(result.error).to eq error("horse_sold")
    end

    it "does not create bid" do
      horse.update(sold_at: Time.current)
      expect do
        described_class.new.create_bid(bid_params)
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when bidder cannot be found" do
    it "returns created false" do
      result = described_class.new.create_bid(bid_params.merge(bidder_id: SecureRandom.uuid))
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_bid(bid_params.merge(bidder_id: SecureRandom.uuid))
      expect(result.error).to eq error("bidder_not_found")
    end

    it "does not create bid" do
      expect do
        described_class.new.create_bid(bid_params.merge(bidder_id: SecureRandom.uuid))
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when bid params are invalid" do
    it "returns created false" do
      result = described_class.new.create_bid(bid_params.merge(current_bid: 500))
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_bid(bid_params.merge(current_bid: 500))
      expect(result.error).to eq "Current bid must be greater than or equal to #{Auctions::Bid::MINIMUM_BID}"
    end

    it "does not create bid" do
      expect do
        result = described_class.new.create_bid(bid_params.merge(current_bid: 500))
        expect(result.bid.errors[:current_bid]).to eq(["must be greater than or equal to #{Auctions::Bid::MINIMUM_BID}"])
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when bid amount is not higher than current bid" do
    it "returns created false" do
      create(:auction_bid, auction:, horse:, current_bid: 1000)
      result = described_class.new.create_bid(bid_params)
      expect(result.created?).to be false
    end

    it "returns error" do
      create(:auction_bid, auction:, horse:, current_bid: 1000)
      result = described_class.new.create_bid(bid_params)
      expect(result.error).to eq "Current bid must be greater than or equal to #{1000 + Auctions::Bid::MINIMUM_INCREMENT}"
    end

    it "does not create bid" do
      create(:auction_bid, auction:, horse:, current_bid: 1000)
      expect do
        described_class.new.create_bid(bid_params)
      end.to change(Auctions::Bid, :count).by(2)
    end
  end

  context "when bid amount is not a <min increment> multiple" do
    it "returns created false" do
      result = described_class.new.create_bid(bid_params.merge(current_bid: 1050))
      expect(result.created?).to be false
    end

    it "returns error" do
      result = described_class.new.create_bid(bid_params.merge(current_bid: 1050))
      expect(result.error).to eq "Bids must be a multiple of #{Auctions::Bid::MINIMUM_INCREMENT}"
    end

    it "does not create bid" do
      expect do
        described_class.new.create_bid(bid_params.merge(current_bid: 1050))
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when bid amount is not <min increment> higher than current bid" do
    it "returns created false" do
      create(:auction_bid, auction:, horse:, current_bid: 1000)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 1050))
      expect(result.created?).to be false
    end

    it "returns error" do
      create(:auction_bid, auction:, horse:, current_bid: 1000)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 1050))
      expect(result.error).to eq "Bids must be a multiple of #{Auctions::Bid::MINIMUM_INCREMENT}"
    end

    it "does not create bid" do
      create(:auction_bid, auction:, horse:, current_bid: 1000)
      expect do
        described_class.new.create_bid(bid_params.merge(current_bid: 1050))
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when bid amount is not higher than maximum bid" do
    it "returns created false" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 6000, maximum_bid: 7000))
      expect(result.created?).to be false
    end

    it "returns error" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 6000, maximum_bid: 7000))
      expect(result.error).to eq "Current bid must be greater than or equal to #{5500 + Auctions::Bid::MINIMUM_INCREMENT}"
    end

    it "creates 2 bids, one for current bidder + one for new current bid" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      expect do
        described_class.new.create_bid(bid_params.merge(current_bid: 6000, maximum_bid: 7000))
      end.to change(Auctions::Bid, :count).by(2)
    end
  end

  context "when bid amount is higher than current bid" do
    it "returns created true" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, updated_at: 1.minute.ago, current_high_bid: true)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 6000, maximum_bid: 20_000))
      expect(result.created?).to be true
    end

    it "returns no error" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, updated_at: 1.minute.ago, current_high_bid: true)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 6000, maximum_bid: 20_000))
      expect(result.error).to be_nil
    end

    it "creates 1 bid for new current bid" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, updated_at: 1.minute.ago, current_high_bid: true)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      expect do
        described_class.new.create_bid(bid_params.merge(current_bid: 6000, maximum_bid: 20_000))
      end.to change(Auctions::Bid, :count).by(1)
    end

    it "updates old bid to not be the current high bid" do
      old_bid = create(:auction_bid, auction:, horse:, current_bid: 5500, updated_at: 1.minute.ago, current_high_bid: true)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      described_class.new.create_bid(bid_params.merge(current_bid: 6000, maximum_bid: 20_000))
      expect(old_bid.reload.current_bid).to eq 5500
      expect(old_bid.current_high_bid).to be false
    end

    it "sets the right data for tne new current bid" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, updated_at: 1.minute.ago, current_high_bid: true)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: 2.minutes.ago)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 6000, maximum_bid: 20_000))
      expect(result.bid).to have_attributes(current_bid: 6000, maximum_bid: 20_000, current_high_bid: true)
    end
  end

  context "when bid amount is higher than maximum bid" do
    it "returns created true" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 10_500, maximum_bid: 20_000))
      expect(result.created?).to be true
    end

    it "returns no error" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 10_500, maximum_bid: 20_000))
      expect(result.error).to be_nil
    end

    it "creates 1 bid for new current bid" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      expect do
        described_class.new.create_bid(bid_params.merge(current_bid: 10_500, maximum_bid: 20_000))
      end.to change(Auctions::Bid, :count).by(1)
    end

    it "updates old bid to the max" do
      old_bid = create(:auction_bid, auction:, horse:, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      described_class.new.create_bid(bid_params.merge(current_bid: 10_500, maximum_bid: 20_000))
      expect(old_bid.reload.current_bid).to eq 10_000
    end

    it "sets the right data for tne new current bid" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      described_class.new.create_bid(bid_params.merge(current_bid: 6000, maximum_bid: 20_000))
      expect(Auctions::Bid.where(horse:).winning.first).to have_attributes(
        current_bid: 10_500,
        maximum_bid: 20_000
      )
    end

    context "when there is already a process sales job queued" do
      before { ActiveJob::Base.queue_adapter = :solid_queue }

      after { ActiveJob::Base.queue_adapter = :test }

      it "does not modify process sales job" do
        old_bidder = create(:stable)
        create(:auction_bid, horse:, auction:, bidder: old_bidder, current_high_bid: true, current_bid: 2000)
        Auctions::ProcessSalesJob.set(wait: 1.hour).perform_later(bidder: old_bidder, auction:)
        expect do
          described_class.new.create_bid(bid_params.merge(current_bid: 10_500, maximum_bid: 20_000))
        end.not_to change(SolidQueue::Job, :count)
      end
    end
  end

  context "when bid amount exactly matches maximum bid" do
    it "returns created true" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 6000, maximum_bid: 10_000))
      expect(result.created?).to be false
    end

    it "returns no error" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 6000, maximum_bid: 10_000))
      expect(result.error).to eq "Current bid must be greater than or equal to 10500"
    end

    it "creates 2 bids" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      expect do
        described_class.new.create_bid(bid_params.merge(current_bid: 6000, maximum_bid: 10_000))
      end.to change(Auctions::Bid, :count).by(2)
    end

    it "updates old bid to the max" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      described_class.new.create_bid(bid_params.merge(current_bid: 10_000, maximum_bid: 10_000))
      under_bid = Auctions::Bid.find_by(horse:, bidder: stable)
      expect(under_bid).to have_attributes(current_bid: 9500, maximum_bid: 10_000)
    end

    it "sets the right data for tne new current bid" do
      create(:auction_bid, auction:, horse:, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      create(:auction_bid, auction:, horse:, current_bid: 5000, maximum_bid: 5000, updated_at: Time.current)
      described_class.new.create_bid(bid_params.merge(current_bid: 6000, maximum_bid: 10_000))
      expect(Auctions::Bid.where(horse:).winning.first).to have_attributes(current_bid: 10_000, maximum_bid: 10_000)
    end
  end

  context "when bidder owns the horse" do
    it "returns created false" do
      horse.horse.update(owner: stable)
      result = described_class.new.create_bid(bid_params)
      expect(result.created?).to be false
    end

    it "returns error" do
      horse.horse.update(owner: stable)
      result = described_class.new.create_bid(bid_params)
      expect(result.error).to eq error("bidder_is_owner")
    end

    it "does not create bid" do
      horse.horse.update(owner: stable)
      expect do
        described_class.new.create_bid(bid_params)
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when bidder has the current high bid" do
    it "returns created false" do
      create(:auction_bid, auction:, horse:, bidder: stable, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 15_000))
      expect(result.created?).to be false
    end

    it "returns error" do
      create(:auction_bid, auction:, horse:, bidder: stable, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 15_000))
      expect(result.error).to eq error("bidder_has_high_bid")
    end

    it "does not create bid" do
      create(:auction_bid, auction:, horse:, bidder: stable, current_bid: 5500, maximum_bid: 10_000, updated_at: 1.minute.ago)
      expect do
        described_class.new.create_bid(bid_params.merge(current_bid: 15_000))
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when bidder has spent the max allowed in the auction" do
    it "returns created false" do
      auction = create(:auction, :current, spending_cap_per_stable: 10_000)
      horse.update(auction:)
      other_bid = create(:auction_bid, auction:, bidder: stable, current_bid: 10_000, maximum_bid: 10_000, updated_at: 1.day.ago)
      other_bid.horse.update(sold_at: Time.current)
      result = described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 10_000))
      expect(result.created?).to be false
    end

    it "returns error" do
      auction = create(:auction, :current, spending_cap_per_stable: 10_000)
      horse.update(auction:)
      other_bid = create(:auction_bid, auction:, bidder: stable, current_bid: 10_000, maximum_bid: 10_000, updated_at: 1.day.ago)
      other_bid.horse.update(sold_at: Time.current)
      result = described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 15_000))
      expect(result.error).to eq error("spent_max_money")
    end

    it "does not create bid" do
      auction = create(:auction, :current, spending_cap_per_stable: 10_000)
      horse.update(auction:)
      other_bid = create(:auction_bid, auction:, bidder: stable, current_bid: 10_000, maximum_bid: 10_000, updated_at: 1.day.ago)
      other_bid.horse.update(sold_at: Time.current)
      expect do
        described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 15_000))
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when bidder is spending more than the max allowed in the auction" do
    it "returns created false" do
      auction = create(:auction, :current, spending_cap_per_stable: 10_000)
      horse.update(auction:)
      result = described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 10_500))
      expect(result.created?).to be false
    end

    it "returns error" do
      auction = create(:auction, :current, spending_cap_per_stable: 10_000)
      horse.update(auction:)
      result = described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 5_000, maximum_bid: 15_000))
      expect(result.error).to eq error("spent_max_money")
    end

    it "does not create bid" do
      auction = create(:auction, :current, spending_cap_per_stable: 10_000)
      horse.update(auction:)
      expect do
        described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 5_000, maximum_bid: 15_000))
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when bidder is spending exactly the max allowed in the auction" do
    it "returns created true" do
      auction = create(:auction, :current, spending_cap_per_stable: 10_000)
      horse.update(auction:)
      result = described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 10_000))
      expect(result.created?).to be true
    end

    it "returns no error" do
      auction = create(:auction, :current, spending_cap_per_stable: 10_000)
      horse.update(auction:)
      result = described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 5_000, maximum_bid: 10_000))
      expect(result.error).to be_nil
    end

    it "creates bid" do
      auction = create(:auction, :current, spending_cap_per_stable: 10_000)
      horse.update(auction:)
      expect do
        described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 5_000, maximum_bid: 10_000))
      end.to change(Auctions::Bid, :count).by(1)
    end
  end

  context "when bidder is spending less than the max allowed in the auction" do
    it "returns created true" do
      auction = create(:auction, :current, spending_cap_per_stable: 10_000)
      horse.update(auction:)
      result = described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 5_000))
      expect(result.created?).to be true
    end

    it "returns no error" do
      auction = create(:auction, :current, spending_cap_per_stable: 10_000)
      horse.update(auction:)
      result = described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 5_000, maximum_bid: 7_500))
      expect(result.error).to be_nil
    end

    it "creates bid" do
      auction = create(:auction, :current, spending_cap_per_stable: 10_000)
      horse.update(auction:)
      expect do
        described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 5_000, maximum_bid: 7_500))
      end.to change(Auctions::Bid, :count).by(1)
    end
  end

  context "when bidder has bought the max horses allowed in the auction" do
    it "returns created false" do
      auction = create(:auction, :current, horse_purchase_cap_per_stable: 1)
      horse.update(auction:)
      other_bid = create(:auction_bid, auction:, bidder: stable, current_bid: 10_000, maximum_bid: 10_000, updated_at: 1.day.ago)
      other_bid.horse.update(sold_at: Time.current)
      other_bid.horse.horse.update(owner: stable)
      result = described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 10_000))
      expect(result.created?).to be false
    end

    it "returns error" do
      auction = create(:auction, :current, horse_purchase_cap_per_stable: 1)
      horse.update(auction:)
      other_bid = create(:auction_bid, auction:, bidder: stable, current_bid: 10_000, maximum_bid: 10_000, updated_at: 1.day.ago)
      other_bid.horse.update(sold_at: Time.current)
      other_bid.horse.horse.update(owner: stable)
      result = described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 15_000))
      expect(result.error).to eq error("bought_max_horses")
    end

    it "does not create bid" do
      auction = create(:auction, :current, horse_purchase_cap_per_stable: 1)
      horse.update(auction:)
      other_bid = create(:auction_bid, auction:, bidder: stable, current_bid: 10_000, maximum_bid: 10_000, updated_at: 1.day.ago)
      other_bid.horse.update(sold_at: Time.current)
      other_bid.horse.horse.update(owner: stable)
      expect do
        described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 15_000))
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when bidder has not yet bought the max horses allowed in the auction" do
    it "returns created true" do
      auction = create(:auction, :current, horse_purchase_cap_per_stable: 2)
      horse.update(auction:)
      other_bid = create(:auction_bid, auction:, bidder: stable, current_bid: 10_000, maximum_bid: 10_000, updated_at: 1.day.ago)
      other_bid.horse.update(sold_at: Time.current)
      result = described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 10_000))
      expect(result.created?).to be true
    end

    it "returns no error" do
      auction = create(:auction, :current, horse_purchase_cap_per_stable: 2)
      horse.update(auction:)
      other_bid = create(:auction_bid, auction:, bidder: stable, current_bid: 10_000, maximum_bid: 10_000, updated_at: 1.day.ago)
      other_bid.horse.update(sold_at: Time.current)
      result = described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 15_000))
      expect(result.error).to be_nil
    end

    it "creates bid" do
      auction = create(:auction, :current, horse_purchase_cap_per_stable: 2)
      horse.update(auction:)
      other_bid = create(:auction_bid, auction:, bidder: stable, current_bid: 10_000, maximum_bid: 10_000, updated_at: 1.day.ago)
      other_bid.horse.update(sold_at: Time.current)
      expect do
        described_class.new.create_bid(bid_params.merge(auction_id: auction.id, current_bid: 15_000))
      end.to change(Auctions::Bid, :count).by(1)
    end
  end

  context "when bidder cannot afford current bid" do
    it "returns created false" do
      legacy_user = create(:legacy_user)
      stable.update(legacy_id: legacy_user.ID, available_balance: 5_000)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 10_000))
      expect(result.created?).to be false
    end

    it "returns error" do
      legacy_user = create(:legacy_user)
      stable.update(legacy_id: legacy_user.ID, available_balance: 5_000)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 10_000))
      expect(result.error).to eq error("cannot_afford_bid")
    end

    it "does not create bid" do
      legacy_user = create(:legacy_user)
      stable.update(legacy_id: legacy_user.ID, available_balance: 5_000)
      expect do
        described_class.new.create_bid(bid_params.merge(current_bid: 10_000))
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when bidder cannot afford maximum bid" do
    it "returns created false" do
      legacy_user = create(:legacy_user)
      stable.update(legacy_id: legacy_user.ID, available_balance: 5_000)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 1000, maximum_bid: 10_000))
      expect(result.created?).to be false
    end

    it "returns error" do
      legacy_user = create(:legacy_user)
      stable.update(legacy_id: legacy_user.ID, available_balance: 5_000)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 1000, maximum_bid: 10_000))
      expect(result.error).to eq error("cannot_afford_bid")
    end

    it "does not create bid" do
      legacy_user = create(:legacy_user)
      stable.update(legacy_id: legacy_user.ID, available_balance: 5_000)
      expect do
        described_class.new.create_bid(bid_params.merge(current_bid: 1000, maximum_bid: 10_000))
      end.not_to change(Auctions::Bid, :count)
    end
  end

  context "when bidder has not met the reserve price" do
    it "returns created false" do
      horse.update(reserve_price: 20_000)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 10_500))
      expect(result.created?).to be true
    end

    it "returns error" do
      horse.update(reserve_price: 20_000)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 5_000, maximum_bid: 15_000))
      expect(result.error).to eq error("reserve_not_met")
    end

    it "creates bid" do
      horse.update(reserve_price: 20_000)
      expect do
        described_class.new.create_bid(bid_params.merge(current_bid: 5_000, maximum_bid: 15_000))
      end.to change(Auctions::Bid, :count).by(1)
    end

    it "sets correct bid amount" do
      horse.update(reserve_price: 20_000)
      described_class.new.create_bid(bid_params.merge(current_bid: 5_000, maximum_bid: 15_000))
      last_bid = Auctions::Bid.find_by(horse:)
      expect(last_bid).to have_attributes(current_bid: 15_000, maximum_bid: 15_000)
    end
  end

  context "when bidder has met the reserve price" do
    it "returns created true" do
      horse.update(reserve_price: 20_000)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 20_500))
      expect(result.created?).to be true
    end

    it "returns no error" do
      horse.update(reserve_price: 20_000)
      result = described_class.new.create_bid(bid_params.merge(current_bid: 5_000, maximum_bid: 20_000))
      expect(result.error).to be_nil
    end

    it "creates bid" do
      horse.update(reserve_price: 20_000)
      expect do
        described_class.new.create_bid(bid_params.merge(current_bid: 5_000, maximum_bid: 20_000))
      end.to change(Auctions::Bid, :count).by(1)
    end

    it "sets correct bid amount" do
      horse.update(reserve_price: 20_000)
      described_class.new.create_bid(bid_params.merge(current_bid: 5_000, maximum_bid: 20_000))
      last_bid = Auctions::Bid.find_by(horse:)
      expect(last_bid).to have_attributes(current_bid: 20_000, maximum_bid: 20_000)
    end
  end

  context "when bid params are valid" do
    it "returns created true" do
      result = described_class.new.create_bid(bid_params)
      expect(result.created?).to be true
    end

    it "returns no error" do
      result = described_class.new.create_bid(bid_params)
      expect(result.error).to be_nil
    end

    it "creates bid" do
      expect do
        described_class.new.create_bid(bid_params)
      end.to change(Auctions::Bid, :count).by(1)
    end
  end

  private

  def error(key)
    I18n.t("services.auctions.bid_creator.#{key}")
  end

  def bid_params
    {
      auction_id: auction.id,
      horse_id: horse.horse_id,
      bidder_id: stable.id,
      current_bid: 1000,
      maximum_bid: nil,
      comment: "Foo"
    }
  end

  def stable
    @stable ||= create(:stable, available_balance: 40_000, total_balance: 50_000)
  end

  def horse
    @horse ||= create(:auction_horse, auction:)
  end

  def auction
    @auction ||= create(:auction, :current)
  end

  def past_auction
    @past_auction ||= create(:auction, :past)
  end
end

