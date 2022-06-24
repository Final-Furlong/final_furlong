require "rails_helper"
require_relative "../shared/horse_examples"

RSpec.describe Stallion, type: :model do
  it_behaves_like "a horse"

  describe "class" do
    it "is a horse" do
      expect(described_class.new).to be_a Horse
    end
  end

  describe "assocations" do
    it { is_expected.to have_many(:foals).class_name("Horse").inverse_of(:sire) }
  end

  describe "validations" do
    describe "status" do
      it "is valid for stallion" do
        horse = build_stubbed(:horse, :stallion)

        expect(horse).to be_valid
      end

      it "is valid for retired_stallion" do
        horse = build_stubbed(:horse, :stallion, status: "retired_stud")

        expect(horse).to be_valid
      end
    end

    describe "gender" do
      it "is valid for stallion" do
        horse = build_stubbed(:horse, :stallion)

        expect(horse).to be_valid
      end

      it "is valid for gelding" do
        horse = build_stubbed(:horse, :stallion, gender: "gelding")

        expect(horse).to be_valid
      end
    end
  end
end

# == Schema Information
#
# Table name: horses
#
#  id               :bigint           not null, primary key
#  date_of_birth    :date             not null, indexed
#  date_of_death    :date
#  gender           :string           not null
#  name             :string
#  status           :enum             default("unborn"), not null, indexed
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  breeder_id       :bigint           indexed
#  dam_id           :bigint           indexed
#  location_bred_id :bigint           indexed
#  owner_id         :bigint           indexed
#  sire_id          :bigint           indexed
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
