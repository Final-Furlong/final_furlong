RSpec.describe AuctionPolicy do
  subject(:policy) { described_class.new(user, auction) }

  let(:user) { build_stubbed(:user) }
  let(:auction) { build_stubbed(:auction) }

  context "when user is a visitor" do
    let(:user) { nil }

    it "does not allow anything" do
      expect(policy).not_to permit_actions(*%i[index show new create edit update destroy])
    end
  end

  context "when user is logged in" do
    let(:user) { create(:user) }

    it "allows main actions + create" do
      expect(policy).to permit_actions(*%i[index show new create])
    end

    context "when user already has max number of upcoming auctions" do
      it "does not allow create" do
        create_list(:auction, Config::Auctions.max_auctions_per_stable + 1, auctioneer: user.stable)
        expect(policy).not_to permit_action(:create)
      end
    end

    context "when user does not have max number of upcoming auctions" do
      it "does allow create" do
        create_list(:auction, Config::Auctions.max_auctions_per_stable + 1, :past, auctioneer: user.stable)
        expect(policy).to permit_action(:create)
      end
    end

    context "when user does own the auction" do
      let(:user) { create(:user) }
      let(:auction) { create(:auction, auctioneer: user.stable) }

      it "allows edit and update" do
        expect(policy).to permit_actions(%i[edit update])
      end

      context "when auction has not started" do
        it "allows destroy" do
          expect(policy).to permit_action(:destroy)
        end
      end

      context "when auction has started" do
        let(:auction) { create(:auction, :past, auctioneer: user.stable) }

        it "does not allow destroy" do
          expect(policy).not_to permit_action(:destroy)
        end
      end
    end

    context "when user does not own the auction" do
      let(:user) { create(:user) }
      let(:auction) { create(:auction) }

      it "does not allow edit or update" do
        expect(policy).not_to permit_actions(%i[edit update])
      end

      it "does not allow destroy" do
        expect(policy).not_to permit_action(:destroy)
      end
    end
  end

  context "when user is an admin" do
    let(:user) { create(:user, admin: true) }

    context "when user does not own the auction" do
      it "does allow edit or update" do
        expect(policy).to permit_actions(%i[edit update])
      end

      context "when auction has not started" do
        it "allows destroy" do
          expect(policy).to permit_action(:destroy)
        end
      end

      context "when auction has started" do
        let(:auction) { create(:auction, :past) }

        it "does not allow destroy" do
          expect(policy).not_to permit_action(:destroy)
        end
      end
    end
  end
end

