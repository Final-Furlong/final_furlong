require "rails_helper"
require_relative "../shared/horse_examples"

RSpec.describe Horse, type: :model do
  it_behaves_like "a horse"

  describe "#status" do
    let(:horse) { build_stubbed(:horse, :broodmare) }

    it "returns HorseStatus" do
      expect(horse.status).to be_a HorseStatus
    end
  end

  describe "#gender" do
    let(:horse) { build_stubbed(:horse, :broodmare) }

    it "returns HorseGender" do
      expect(horse.gender).to be_a HorseGender
    end
  end

  describe "#age" do
    context "when stillborn" do
      let(:horse) { build_stubbed(:horse, :stillborn) }

      it "returns 0" do
        expect(horse.age).to eq 0
      end
    end

    context "when alive" do
      let(:date_of_birth) { Date.current - 3.years }
      let(:date_of_death) { nil }
      let(:horse) { build_stubbed(:horse, date_of_birth:, date_of_death:) }

      it "returns current age" do
        expect(horse.age).to eq 3
      end
    end

    context "when deceased" do
      let(:date_of_birth) { Date.current - 8.years }
      let(:date_of_death) { Date.current - 1.year }
      let(:horse) { build_stubbed(:horse, date_of_birth:, date_of_death:) }

      it "returns age at death" do
        expect(horse.age).to eq 7
      end
    end
  end

  describe "#stillborn?" do
    context "when date of birth == date of death" do
      let(:horse) { build_stubbed(:horse, :stillborn) }

      it "returns true" do
        expect(horse.stillborn?).to be true
      end
    end

    context "when date of birth != date of death" do
      let(:horse) { build_stubbed(:horse) }

      it "returns false" do
        expect(horse.stillborn?).to be false
      end
    end
  end
end

# == Schema Information
#
# Table name: horses
#
#  id                                                                                                                         :bigint           not null, primary key
#  date_of_birth                                                                                                              :date             not null, indexed
#  date_of_death                                                                                                              :date
#  gender(colt, filly, mare, stallion, gelding)                                                                               :string           not null
#  name                                                                                                                       :string
#  status(unborn, weanling, yearling, racehorse, broodmare,
#    stallion, retired, retired_broodmare, retired_stallion,
#    deceased) :enum  default("unborn"), not null, indexed
#  created_at                                                                                                                 :datetime         not null
#  updated_at                                                                                                                 :datetime         not null
#  breeder_id                                                                                                                 :bigint           indexed
#  dam_id                                                                                                                     :bigint           indexed
#  location_bred_id                                                                                                           :bigint           indexed
#  owner_id                                                                                                                   :bigint           indexed
#  sire_id                                                                                                                    :bigint           indexed
#
# Indexes
#
#  index_horses_on_breeder_id        (breeder_id)
#  index_horses_on_dam_id            (dam_id)
#  index_horses_on_date_of_birth     (date_of_birth)
#  index_horses_on_location_bred_id  (location_bred_id)
#  index_horses_on_owner_id          (owner_id)
#  index_horses_on_sire_id           (sire_id)
#  index_horses_on_status            (status)
#
# Foreign Keys
#
#  fk_rails_...  (breeder_id => stables.id)
#  fk_rails_...  (dam_id => horses.id)
#  fk_rails_...  (location_bred_id => racetracks.id)
#  fk_rails_...  (owner_id => stables.id)
#  fk_rails_...  (sire_id => horses.id)
#
