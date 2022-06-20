require "rails_helper"

RSpec.describe Stallion do
  describe "class" do
    it "is a horse" do
      expect(described_class.new).to be_a Horse
    end
  end

  describe "assocations" do
    it { is_expected.to have_many(:foals).class_name("Horse").inverse_of(:sire) }
  end

  describe "validations" do
    it { is_expected.to validate_inclusion_of(:status).in_array(HorseStatus::MALE_BREEDING_STATUSES) }
    it { is_expected.to validate_inclusion_of(:gender).in_array(%w[stallion gelding]) }
  end
end
