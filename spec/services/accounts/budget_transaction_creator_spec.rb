RSpec.describe Accounts::BudgetTransactionCreator do
  describe "#create_transaction" do
    context "when opening balance for stable" do
      it "creates budget transaction" do
        expect do
          described_class.new.create_transaction(stable:, description: "Opening Balance", amount:)
        end.to change(Account::Budget, :count).by(1)
      end

      it "sets stable balances" do
        described_class.new.create_transaction(stable:, description: "Opening Balance", amount: 50_000)
        expect(stable.reload.total_balance).to eq 50_000
        expect(stable.reload.available_balance).to eq 50_000
      end
    end

    context "when stable already has transactions" do
      before { described_class.new.create_transaction(stable:, description: "Opening Balance", amount: 50_000) }

      it "creates budget transaction" do
        expect do
          described_class.new.create_transaction(stable:, description: "bought a horse", amount:)
        end.to change(Account::Budget, :count).by(1)
        expect(Account::Budget.recent.first).to have_attributes(
          stable:,
          amount:,
          balance: 45_000
        )
      end

      it "sets stable balances" do
        described_class.new.create_transaction(stable:, description: "bought a horse", amount:)
        expect(stable.reload.total_balance).to eq 45_000
        expect(stable.reload.available_balance).to eq 45_000
      end
    end

    context "when set to increment available balance" do
      before { described_class.new.create_transaction(stable:, description: "Opening Balance", amount: 50_000) }

      it "updates stable available balance" do
        stable.update(available_balance: 40_000)
        described_class.new.create_transaction(stable:, description: "bought a horse", amount:, increment_available_balance: true)
        expect(stable.reload.total_balance).to eq 45_000
        expect(stable.reload.available_balance).to eq 45_000
      end
    end

    context "when activity type is provided" do
      it "updates stable available balance" do
        mock_creator = instance_double(Accounts::ActivityTransactionCreator, create_transaction: true)
        allow(Accounts::ActivityTransactionCreator).to receive(:new).and_return mock_creator

        activity_type = "buying"
        described_class.new.create_transaction(stable:, description: "bought a horse", amount:, activity_type:)
        new_budget = Account::Budget.recent.first
        expect(mock_creator).to have_received(:create_transaction).with(stable:, activity_type:, budget: new_budget)
      end
    end

    describe "budget activity type" do
      it "handles race entry entries" do
        described_class.new.create_transaction(stable:, description: "Entry Fee: Rocket", amount:)
        new_budget = Account::Budget.recent.first
        expect(new_budget.activity_type).to eq "entered_race"
      end

      it "handles race winning entries" do
        described_class.new.create_transaction(stable:, description: "Race Winnings: Rocket", amount:)
        new_budget = Account::Budget.recent.first
        expect(new_budget.activity_type).to eq "race_winnings"
      end

      it "handles jockey fee entries" do
        described_class.new.create_transaction(stable:, description: "Jockey Fee: Rocket", amount:)
        new_budget = Account::Budget.recent.first
        expect(new_budget.activity_type).to eq "jockey_fee"
      end

      it "handles stud fee entries" do
        described_class.new.create_transaction(stable:, description: "Stud Booking: Rocket", amount:)
        new_budget = Account::Budget.recent.first
        expect(new_budget.activity_type).to eq "bred_stud"
      end

      it "handles mare breeding entries" do
        described_class.new.create_transaction(stable:, description: "Breeding: Rocket", amount:)
        new_budget = Account::Budget.recent.first
        expect(new_budget.activity_type).to eq "bred_mare"
      end

      it "handles claiming entries" do
        ["Claimed: Rocket", "Claim: Rocket"].each do |description|
          described_class.new.create_transaction(stable:, description:, amount:)
          new_budget = Account::Budget.recent.first
          expect(new_budget.activity_type).to eq "claimed_horse"
        end
      end

      it "handles shipping entries" do
        described_class.new.create_transaction(stable:, description: "Shipped Rocket to track", amount:)
        new_budget = Account::Budget.recent.first
        expect(new_budget.activity_type).to eq "shipped_horse"
      end

      it "handles BS nomination entries" do
        described_class.new.create_transaction(stable:, description: "2025 Breeders' Series Nomination: 2yo Turf", amount:)
        new_budget = Account::Budget.recent.first
        expect(new_budget.activity_type).to eq "nominated_breeders_series"
      end

      it "handles boarding entries" do
        described_class.new.create_transaction(stable:, description: "Board for Rocket for 10 days", amount:)
        new_budget = Account::Budget.recent.first
        expect(new_budget.activity_type).to eq "boarded_horse"
      end

      it "handles breeders' series winning entries" do
        described_class.new.create_transaction(stable:, description: "2025 Breeders' Series 2yo Turf Winner", amount:)
        new_budget = Account::Budget.recent.first
        expect(new_budget.activity_type).to eq "won_breeders_series"
      end

      it "handles misc entries" do
        described_class.new.create_transaction(stable:, description: "Something random", amount:)
        new_budget = Account::Budget.recent.first
        expect(new_budget.activity_type).to eq "misc"
      end

      it "handles stud nomination entries" do
        described_class.new.create_transaction(stable:, description: "Breeders' Cup Stallion Nomination: Rocket", amount:)
        new_budget = Account::Budget.recent.first
        expect(new_budget.activity_type).to eq "nominated_stallion"
      end

      it "handles sale entries" do
        ["Sold Rocket", "Stable Auction: Sold Rocket"].each do |description|
          described_class.new.create_transaction(stable:, description:, amount:)
          new_budget = Account::Budget.recent.first
          expect(new_budget.activity_type).to eq "sold_horse"
        end
      end

      it "handles purchase entries" do
        ["Purchased Rocket", "Adoption Agency - Purchased Rocket", "Stable Auction: Purchased Rocket"].each do |description|
          described_class.new.create_transaction(stable:, description:, amount:)
          new_budget = Account::Budget.recent.first
          expect(new_budget.activity_type).to eq "bought_horse"
        end
      end

      it "handles racehorse nomination entries" do
        ["Race Nomination: Rocket", "Late Breeders' Cup Nomination: Rocket", "Supplemental Nomination: Rocket"].each do |description|
          described_class.new.create_transaction(stable:, description:, amount:)
          new_budget = Account::Budget.recent.first
          expect(new_budget.activity_type).to eq "nominated_racehorse"
        end
      end

      it "handles tax entries" do
        %w[Racehorse Broodmare Stallion Yearling/Weanling Sales Stable].each do |tax|
          description = "#{Date.current.year} #{tax} Tax"
          described_class.new.create_transaction(stable:, description:, amount:)
          new_budget = Account::Budget.recent.first
          expect(new_budget.activity_type).to eq "paid_tax"
        end
      end

      it "handles handicapping entries" do
        ["Handicapping Races", "July Handicapping Races: Rocket", "July Handicapping: Rocket"].each do |description|
          described_class.new.create_transaction(stable:, description:, amount:)
          new_budget = Account::Budget.recent.first
          expect(new_budget.activity_type).to eq "handicapping_races"
        end
      end

      it "handles consigning entries" do
        ["Consigned Rocket to Auction", "Consigning Rocket to Auction"].each do |description|
          described_class.new.create_transaction(stable:, description:, amount:)
          new_budget = Account::Budget.recent.first
          expect(new_budget.activity_type).to eq "consigned_auction"
        end
      end

      it "handles leasing entries" do
        ["Lease Fee: Rocket", "Lease Refund: Rocket", "Lease Terminated: Rocket", "Leased Rocket to Stable"].each do |description|
          described_class.new.create_transaction(stable:, description:, amount:)
          new_budget = Account::Budget.recent.first
          expect(new_budget.activity_type).to eq "leased_horse"
        end
      end

      it "handles color war entries" do
        ["2025 Color War", "2025 Color War: Winnings", "Won Color War 2025"].each do |description|
          described_class.new.create_transaction(stable:, description:, amount:)
          new_budget = Account::Budget.recent.first
          expect(new_budget.activity_type).to eq "color_war"
        end
      end

      it "handles activity poins entries" do
        ["Redeemed Activity Points: Bought Rocket", "Redeemed 100 Activity Points"].each do |description|
          described_class.new.create_transaction(stable:, description:, amount:)
          new_budget = Account::Budget.recent.first
          expect(new_budget.activity_type).to eq "activity_points"
        end
      end

      it "handles donation entries" do
        descriptions = ["Thanks for your donation to FF", "Thanks for your donation!",
          "Thanks for your generous donation to FF", "Thank you for your generous donation to FF",
          "Thanks for donating to Final Furlong", "Thanks for donation to Final Furlong",
          "Thank you for your donation to Final Furlong", "Thanks for your donation towards Final Furlong"]
        descriptions.each do |description|
          described_class.new.create_transaction(stable:, description:, amount:)
          new_budget = Account::Budget.recent.first
          expect(new_budget.activity_type).to eq "donation"
        end
      end
    end
  end

  private

  def stable
    @stable ||= create(:stable)
  end

  def amount
    -5000
  end
end

