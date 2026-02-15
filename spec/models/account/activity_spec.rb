RSpec.describe Account::Activity do
  describe "associations" do
    it { is_expected.to belong_to(:stable) }
    it { is_expected.to belong_to(:budget).optional }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:activity_type) }
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:balance) }
    it { is_expected.to validate_presence_of(:legacy_stable_id) }
    it { is_expected.to validate_inclusion_of(:activity_type).in_array(Config::Game.activity_types) }
  end
end

