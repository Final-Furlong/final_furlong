require "rails_helper"

RSpec.describe Racetrack do
  describe "associations" do
    it { is_expected.to belong_to(:location) }
    it { is_expected.to have_many(:surfaces).class_name("TrackSurface") }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_least(4) }

    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_numericality_of(:longitude).is_less_than_or_equal_to(180) }
    it { is_expected.to validate_numericality_of(:longitude).is_greater_than_or_equal_to(-180) }

    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_numericality_of(:latitude).is_less_than_or_equal_to(90) }
    it { is_expected.to validate_numericality_of(:latitude).is_greater_than_or_equal_to(-90) }

    it "validates unique name" do
      racetrack = create(:racetrack)
      new_racetrack = build(:racetrack, name: racetrack.name.upcase)

      expect(new_racetrack).not_to be_valid
      expect(new_racetrack.errors[:name]).to eq(["has already been taken"])
    end
  end
end

