RSpec.describe Auctions::HorseSeller do
  attr_reader :bid, :auction, :auction_horse, :horse, :legacy_stable_buyer,
    :legacy_stable_seller, :legacy_buyer_balance, :legacy_seller_balance,
    :legacy_horse, :legacy_training_schedule, :legacy_training_schedule_horse,
    :legacy_race_entry, :legacy_foal_1, :legacy_foal_2, :foal_1, :foal_2,
    :seller, :buyer

  shared_examples "an unprocessed sale" do
    it "does not create budget entries" do
      expect { described_class.new.process_sale(bid:) }.not_to change(Account::Budget, :count)
    end

    it "does not modify horse" do
      expect { described_class.new.process_sale(bid:) }.not_to change(horse, :reload)
    end
  end

  shared_examples "a processed sale" do
    it "creates budget entries" do
      expect { described_class.new.process_sale(bid:) }.to change(Account::Budget, :count).by(2)
    end

    it "creates budget entry for buyer" do
      described_class.new.process_sale(bid:)
      budget = Account::Budget.where(stable: @buyer).recent.first
      expect(budget).to have_attributes(
        description: "#{auction.title}: Purchased #{horse.name} (ID# #{horse.legacy_id}) from #{seller.name}",
        amount: bid.current_bid * -1,
        balance: bid.current_bid * -1
      )
    end

    it "creates budget entry for seller" do
      described_class.new.process_sale(bid:)
      budget = Account::Budget.where(stable: @seller).recent.first
      expect(budget).to have_attributes(
        description: "#{auction.title}: Sold #{horse.name} (ID# #{horse.legacy_id}) to #{buyer.name}",
        amount: bid.current_bid,
        balance: bid.current_bid
      )
    end

    it "modifies legacy stable for buyer" do
      original_available_balance = buyer.available_balance
      original_total_balance = buyer.total_balance
      described_class.new.process_sale(bid:)
      expect(buyer.reload).to have_attributes(
        available_balance: original_available_balance - bid.current_bid,
        total_balance: original_total_balance - bid.current_bid
      )
    end

    it "modifies legacy stable for seller" do
      original_available_balance = seller.available_balance
      original_total_balance = seller.total_balance
      described_class.new.process_sale(bid:)
      expect(seller.reload).to have_attributes(
        available_balance: original_available_balance + bid.current_bid,
        total_balance: original_total_balance + bid.current_bid
      )
    end

    it "deletes training schedules" do
      expect { described_class.new.process_sale(bid:) }.to change(Legacy::TrainingSchedule, :count).by(-1)
    end

    it "deletes training schedule horses" do
      expect { described_class.new.process_sale(bid:) }.to change(Legacy::TrainingScheduleHorse, :count).by(-1)
    end

    it "modifies racehorse view" do
      allow(Legacy::ViewRacehorses).to receive(:where).and_call_original
      described_class.new.process_sale(bid:)
      expect(Legacy::ViewRacehorses).to have_received(:where)
    end

    it "creates horse sale transaction" do
      expect { described_class.new.process_sale(bid:) }.to change(Legacy::HorseSale, :count).by(1)
    end

    it "modifies legacy horse" do
      described_class.new.process_sale(bid:)
      expect(legacy_horse.reload).to have_attributes(
        Owner: buyer.legacy_id,
        SalePrice: -1,
        SellTo: 0,
        can_be_sold: false,
        consigned_auction_id: nil
      )
    end

    it "modifies training schedule view" do
      allow(Legacy::ViewTrainingSchedules).to receive(:where).and_call_original
      described_class.new.process_sale(bid:)
      expect(Legacy::ViewTrainingSchedules).to have_received(:where)
    end

    it "deletes race entry" do
      expect { described_class.new.process_sale(bid:) }.to change(Legacy::RaceEntry, :count).by(-1)
    end

    it "updates legacy unborn foals" do
      described_class.new.process_sale(bid:)
      expect(legacy_foal_1.reload).to have_attributes(Owner: legacy_stable_buyer.ID)
      expect(legacy_foal_2.reload).to have_attributes(Owner: legacy_stable_buyer.ID)
    end

    it "updates unborn foals" do
      described_class.new.process_sale(bid:)
      expect(foal_1.reload).to have_attributes(owner: bid.bidder)
      expect(foal_2.reload).to have_attributes(owner: bid.bidder)
    end

    it "modifies auction horse" do
      described_class.new.process_sale(bid:)
      expect(auction_horse.reload[:sold_at]).not_to be_nil
    end

    it "modifies horse" do
      described_class.new.process_sale(bid:)
      expect(horse.reload).to have_attributes(owner: bid.bidder)
    end
  end

  before { setup_data }

  context "when auction is not active" do
    before { auction.update_columns(start_time: DateTime.current - 10.days, end_time: DateTime.current - 1.day) }

    it "returns sold false" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be false
    end

    it "returns error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to eq "Auction is not active"
    end

    it_behaves_like "an unprocessed sale"
  end

  context "when auction horse is sold" do
    before { auction_horse.update(sold_at: 1.day.ago) }

    it "returns sold false" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be false
    end

    it "returns error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to eq error("horse_sold")
    end

    it_behaves_like "an unprocessed sale"
  end

  context "when sale time has not been met" do
    before do
      bid.update(updated_at: DateTime.current - auction.hours_until_sold.hours + 5.minutes)
      auction.update_column(:end_time, DateTime.current + 2.days)
    end

    it "returns sold false" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be false
    end

    it "returns error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to eq error("bid_timeout_not_met")
    end

    it_behaves_like "an unprocessed sale"
  end

  context "when sale time has not been met but auction is ending" do
    before do
      bid.update(updated_at: DateTime.current - 1.hour)
      auction.update_column(:end_time, 5.minutes.ago)
    end

    it "returns sold true" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be true
    end

    it "returns no error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to be_nil
    end

    it_behaves_like "a processed sale"
  end

  context "when bidder owns the horse" do
    before { horse.update(owner: bid.bidder) }

    it "returns sold false" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be false
    end

    it "returns error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to eq error("bidder_is_owner")
    end

    it_behaves_like "an unprocessed sale"
  end

  context "when bidder has spent the max allowed in the auction" do
    before do
      auction.update(spending_cap_per_stable: 10_000)
      other_bid = create(:auction_bid, auction:, bidder: bid.bidder, current_bid: 10_000, maximum_bid: 10_000, updated_at: 1.day.ago)
      other_bid.horse.update(sold_at: Time.current)
    end

    it "returns sold false" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be false
    end

    it "returns error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to eq error("spent_max_money")
    end

    it_behaves_like "an unprocessed sale"
  end

  context "when bidder is spending more than the max allowed in the auction" do
    before do
      auction.update(spending_cap_per_stable: 10_000)
      bid.update(current_bid: 10_500, updated_at: Time.current - auction.hours_until_sold.hours - 1.minute)
    end

    it "returns sold false" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be false
    end

    it "returns error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to eq error("spent_max_money")
    end

    it_behaves_like "an unprocessed sale"
  end

  context "when bidder is spending exactly the max allowed in the auction" do
    before do
      auction.update(spending_cap_per_stable: 10_000)
      bid.update(current_bid: 10_000, updated_at: Time.current - auction.hours_until_sold.hours - 1.minute)
    end

    it "returns sold true" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be true
    end

    it "returns no error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to be_nil
    end

    it_behaves_like "a processed sale"
  end

  context "when bidder is spending less than the max allowed in the auction" do
    before do
      auction.update(spending_cap_per_stable: 10_000)
      bid.update(current_bid: 9_000, updated_at: Time.current - auction.hours_until_sold.hours - 1.minute)
    end

    it "returns sold true" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be true
    end

    it "returns no error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to be_nil
    end

    it_behaves_like "a processed sale"
  end

  context "when bidder has bought the max horses allowed in the auction" do
    before do
      auction.update(horse_purchase_cap_per_stable: 1)
      other_bid = create(:auction_bid, auction:, bidder: bid.bidder, current_bid: 10_000, maximum_bid: 10_000, updated_at: 1.day.ago)
      other_bid.horse.update(sold_at: Time.current)
      other_bid.horse.horse.update(owner: bid.bidder)
    end

    it "returns sold false" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be false
    end

    it "returns error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to eq error("bought_max_horses")
    end

    it_behaves_like "an unprocessed sale"
  end

  context "when bidder has not yet bought the max horses allowed in the auction" do
    before do
      auction.update(horse_purchase_cap_per_stable: 2)
      other_bid = create(:auction_bid, auction:, bidder: bid.bidder, current_bid: 10_000, maximum_bid: 10_000, updated_at: 1.day.ago)
      other_bid.horse.update(sold_at: Time.current)
    end

    it "returns sold true" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be true
    end

    it "returns no error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to be_nil
    end

    it_behaves_like "a processed sale"
  end

  context "when bidder cannot afford current bid" do
    before { buyer.update(available_balance: 500) }

    it "returns sold false" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be false
    end

    it "returns error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to eq error("cannot_afford_bid")
    end

    it "triggers deletion of bid" do
      mock_deleter = instance_double(Auctions::BidDeleter, delete_bids: true)
      allow(Auctions::BidDeleter).to receive(:new).and_return mock_deleter
      described_class.new.process_sale(bid:)
      expect(mock_deleter).to have_received(:delete_bids).with(bids: [bid])
    end

    it_behaves_like "an unprocessed sale"
  end

  context "when bidder cannot afford current bid and does not have a balance" do
    before { buyer.update(available_balance: nil) }

    it "returns sold false" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be false
    end

    it "returns error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to eq error("cannot_afford_bid")
    end

    it_behaves_like "an unprocessed sale"
  end

  context "when bidder has not met the reserve price" do
    before do
      auction_horse.update(reserve_price: 20_000)
      bid.update(current_bid: 10_000, maximum_bid: 10_000, updated_at: Time.current - auction.hours_until_sold.hours - 1.minute)
    end

    it "returns sold false" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be false
    end

    it "returns error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to eq error("reserve_not_met")
    end

    it_behaves_like "an unprocessed sale"
  end

  context "when bidder has met the reserve price" do
    before do
      auction_horse.update(reserve_price: 20_000)
      bid.update(current_bid: 20_000, updated_at: Time.current - auction.hours_until_sold.hours - 1.minute)
    end

    it "returns sold true" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be true
    end

    it "returns no error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to be_nil
    end

    it_behaves_like "a processed sale"
  end

  context "when horse has a maximum_price set" do
    before do
      auction_horse.update(maximum_price: 100_000)
      bid.update(current_bid: 100_000, updated_at: Time.current - auction.hours_until_sold.hours - 1.minute)
    end

    context "when bidder is spending exactly the max price and is the only bidder" do
      it "returns sold true" do
        result = described_class.new.process_sale(bid:)
        expect(result.sold?).to be true
      end

      it "returns no error" do
        result = described_class.new.process_sale(bid:)
        expect(result.error).to be_nil
      end

      it_behaves_like "a processed sale"
    end

    context "when multiple bidders are spending the max price" do
      before do
        @bid2 = create(:auction_bid, auction:, horse: bid.horse, current_bid: 100_000)
        @other_winning_bidder = @bid2.bidder
        @legacy_stable_buyer_2 = create(:legacy_user)
        @bid2.bidder.update(legacy_id: @legacy_stable_buyer_2.ID)
      end

      context "when other bidder cannot afford the max price" do
        before do
          @bid2.bidder.update(available_balance: 50_000, total_balance: 50_000)
        end

        it "returns sold true" do
          result = described_class.new.process_sale(bid:)
          expect(result.sold?).to be true
        end

        it "returns no error" do
          result = described_class.new.process_sale(bid:)
          expect(result.error).to be_nil
        end

        it "sells to the first bidder" do
          described_class.new.process_sale(bid:)
          expect(horse.reload).to have_attributes(owner: buyer)
        end
      end

      context "when all bidders cannot afford the max price" do
        before do
          @bid2.bidder.update(available_balance: 50_000, total_balance: 50_000)
          buyer.update(available_balance: 500)
        end

        it "returns sold true" do
          result = described_class.new.process_sale(bid:)
          expect(result.sold?).to be false
        end

        it "returns no error" do
          result = described_class.new.process_sale(bid:)
          expect(result.error).to eq error("cannot_afford_bid")
        end

        it "triggers bid deletion for all bids" do
          mock_deleter = instance_double(Auctions::BidDeleter, delete_bids: true)
          allow(Auctions::BidDeleter).to receive(:new).and_return mock_deleter
          described_class.new.process_sale(bid:)
          expect(mock_deleter).to have_received(:delete_bids).with(bids: [bid, @bid2])
        end

        it_behaves_like "an unprocessed sale"
      end

      context "when other bidder can afford the max price" do
        it "returns sold true" do
          result = described_class.new.process_sale(bid:)
          expect(result.sold?).to be true
        end

        it "returns no error" do
          result = described_class.new.process_sale(bid:)
          expect(result.error).to be_nil
        end

        it "sells to one of the max bidders" do
          described_class.new.process_sale(bid:)
          expect([buyer, @other_winning_bidder]).to include(horse.reload.owner)
        end
      end
    end
  end

  context "when bid params are valid" do
    it "returns sold true" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be true
    end

    it "returns no error" do
      result = described_class.new.process_sale(bid:)
      expect(result.error).to be_nil
    end

    it_behaves_like "a processed sale"
  end

  context "when horse is not entered in a claiming race" do
    before { legacy_race_entry.race.type.update(Type: "NW1 Allowance") }

    it "returns sold true" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be true
    end

    it "does not delete race entry" do
      expect do
        described_class.new.process_sale(bid:)
      end.not_to change(Legacy::RaceEntry, :count)
    end
  end

  context "when horse is not the dam of unborn foals" do
    before do
      legacy_foal_1.destroy
      legacy_foal_2.destroy
      foal_1.destroy
      foal_2.destroy
    end

    it "returns sold true" do
      result = described_class.new.process_sale(bid:)
      expect(result.sold?).to be true
    end
  end

  private

  def error(key)
    I18n.t("services.auctions.horse_seller.#{key}")
  end

  def setup_data
    @auction = create(:auction, :current)
    @bid = create(:auction_bid, auction:, updated_at: Time.current - auction.hours_until_sold.hours - 1.minute)
    @auction_horse = @bid.horse
    @legacy_stable_buyer = create(:legacy_user)
    @bid.bidder.update(legacy_id: legacy_stable_buyer.ID)
    @legacy_stable_seller = create(:legacy_user)
    @legacy_horse = create(:legacy_horse, Owner: legacy_stable_seller, consignd_auction_id: auction.id)
    @horse = @auction_horse.horse
    @buyer = bid.bidder
    @seller = horse.owner
    @buyer.update(available_balance: 200_000, total_balance: 200_000)
    @seller.update(available_balance: 200_000, total_balance: 200_000)
    horse.update(legacy_id: legacy_horse.ID)
    horse.owner.update(legacy_id: legacy_stable_seller.ID)
    @legacy_training_schedule = Legacy::TrainingSchedule.create!(
      Horse: legacy_horse.ID,
      Name: SecureRandom.alphanumeric(20),
      Stable: legacy_stable_seller.ID
    )
    @legacy_training_schedule_horse = Legacy::TrainingScheduleHorse.create!(
      Horse: legacy_horse.ID,
      Schedule: legacy_training_schedule.ID
    )
    legacy_race_type = Legacy::RaceType.create!(ID: 2, Type: "Claiming")
    legacy_race = Legacy::Race.create!(
      Age: 2,
      Date: Date.current,
      DayNum: 1,
      Distance: 8.5,
      Location: 10,
      Type: legacy_race_type.ID
    )
    @legacy_race_entry = Legacy::RaceEntry.create!(
      Race: legacy_race.ID,
      EntryDate: Date.current + 1.day,
      Horse: legacy_horse.ID
    )
    @legacy_foal_1 = create(:legacy_horse, :unborn, Dam: legacy_horse.ID)
    @legacy_foal_2 = create(:legacy_horse, :unborn, Dam: legacy_horse.ID)
    @foal_1 = create(:horse, :unborn, dam: horse)
    @foal_2 = create(:horse, :unborn, dam: horse)
  end
end

