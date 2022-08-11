require "rails_helper"

RSpec.shared_examples "a horse" do
  describe "assocations" do
    it { is_expected.to belong_to(:breeder).class_name("Stable") }
    it { is_expected.to belong_to(:owner).class_name("Stable") }
    it { is_expected.to belong_to(:sire).class_name("Horse").optional }
    it { is_expected.to belong_to(:dam).class_name("Horse").optional }
    it { is_expected.to belong_to(:location_bred).class_name("Location") }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:date_of_birth) }
  end
end
