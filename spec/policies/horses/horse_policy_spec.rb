RSpec.describe Horses::HorsePolicy do
  subject(:policy) { described_class.new(user, horse) }

  let(:user) { build_stubbed(:user) }
  let(:horse) { build_stubbed(:horse, name: nil) }

  describe "scope" do
    subject(:scope) { described_class::Scope.new(user, Horses::Horse.all).resolve }

    it "includes born horses" do
      expect(scope).to eq Horses::HorsesQuery.new.born
    end
  end

  shared_examples "not permitting anything for an unborn horse" do
    let(:horse) { build_stubbed(:horse, :unborn) }

    it "does not allow the correct actions" do
      expect(policy).not_to permit_actions(:show, :image, :thumbnail, :edit_name, :update)
    end
  end

  context "when user is a visitor" do
    let(:user) { nil }

    it "allows public actions" do
      expect(policy).to permit_actions(:index, :show, :image, :thumbnail)
    end

    it_behaves_like "not permitting anything for an unborn horse"
  end

  context "when user is logged in and does not own the horse" do
    let(:user) { create(:user) }

    it "allows public actions" do
      expect(policy).to permit_actions(:index, :show, :image, :thumbnail)
    end

    it "denies private actions" do
      expect(policy).not_to permit_actions(:edit_name, :update)
    end

    it_behaves_like "not permitting anything for an unborn horse"
  end

  context "when user is logged in and does own the horse" do
    let(:user) { create(:user) }
    let(:horse) { build_stubbed(:horse, owner: user.stable) }

    it "allows public actions" do
      expect(policy).to permit_actions(:index, :show, :image, :thumbnail)
    end

    context "when horse is eligible for naming" do
      it "allows when horse is 0yo" do
        horse.date_of_birth = Date.new(Date.current.year, 1, 1)
        horse.status = "weanling"
        expect(policy).to permit_actions(:index, :show, :image, :thumbnail, :edit_name, :update)
      end

      it "allows when horse is 1yo" do
        horse.date_of_birth = Date.current - 1.year
        horse.status = "yearling"
        expect(policy).to permit_actions(:index, :show, :image, :thumbnail, :edit_name, :update)
      end

      it "allows when horse is 2yo and created" do
        horse.date_of_birth = Date.current - 2.years
        horse.sire_id = nil
        horse.dam_id = nil
        horse.name = nil
        horse.status = "racehorse"
        expect(policy).to permit_actions(:index, :show, :image, :thumbnail, :edit_name, :update)
      end
    end

    context "when horse is ineligible for naming" do
      it "denies when horse is dead" do
        horse.status = "deceased"
        expect(policy).to permit_actions(:index, :show, :image, :thumbnail)
        expect(policy).not_to permit_actions(:edit_name, :update)
      end

      it "denies when horse is 2yo and created and has a name" do
        horse.date_of_birth = Date.current - 2.years
        horse.name = "Bob"
        horse.sire_id = nil
        horse.dam_id = nil
        horse.status = "racehorse"
        expect(policy).to permit_actions(:index, :show, :image, :thumbnail)
        expect(policy).not_to permit_actions(:edit_name, :update)
      end

      it "denies when horse is 2yo and not created" do
        horse.date_of_birth = Date.current - 2.years
        horse.sire = build(:sire)
        horse.dam_id = build(:dam)
        horse.name = nil
        horse.status = "racehorse"
        expect(policy).to permit_actions(:index, :show, :image, :thumbnail)
        expect(policy).not_to permit_actions(:edit_name, :update)
      end

      context "when horse has activity" do
        let(:horse) { create(:horse, name: nil, sire_id: nil, dam_id: nil, owner: user.stable) }

        it "denies when horse has raced" do
          create(:race_result_horse, horse:)
          expect(policy).to permit_actions(:index, :show, :image, :thumbnail)
          expect(policy).not_to permit_actions(:edit_name, :update)
        end

        it "denies when horse has foals" do
          create(:horse, dam: horse)
          expect(policy).to permit_actions(:index, :show, :image, :thumbnail)
          expect(policy).not_to permit_actions(:edit_name, :update)
        end

        it "denies when horse has stud foals" do
          create(:horse, sire: horse)
          expect(policy).to permit_actions(:index, :show, :image, :thumbnail)
          expect(policy).not_to permit_actions(:edit_name, :update)
        end
      end
    end

    it_behaves_like "not permitting anything for an unborn horse"
  end

  context "when user is an admin" do
    let(:user) { create(:user, admin: true) }

    it "allows public actions" do
      expect(policy).to permit_actions(:index, :show, :image, :thumbnail)
    end

    it "denies private actions" do
      expect(policy).not_to permit_actions(:edit_name, :update)
    end

    it_behaves_like "not permitting anything for an unborn horse"
  end
end

