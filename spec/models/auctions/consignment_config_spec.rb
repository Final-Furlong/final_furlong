RSpec.describe Auctions::ConsignmentConfig do
  describe "associations" do
    it { is_expected.to belong_to(:auction).class_name("::Auction") }
  end

  describe "validations" do
    subject(:config) { build(:auction_consignment_config) }

    it { is_expected.to validate_presence_of(:horse_type) }
    it { is_expected.to validate_uniqueness_of(:horse_type).case_insensitive.scoped_to(:auction_id) }
    it { is_expected.to validate_inclusion_of(:horse_type).in_array(described_class::HORSE_TYPES) }
    it { is_expected.to validate_numericality_of(:minimum_count).is_greater_than(0) }

    context "when horse type is racehorse" do
      subject(:config) { build(:auction_consignment_config, horse_type: "racehorse") }

      it { is_expected.to validate_numericality_of(:minimum_age).is_greater_than_or_equal_to(2).is_less_than_or_equal_to(3) }
      it { is_expected.to validate_numericality_of(:maximum_age).is_greater_than_or_equal_to(2).is_less_than_or_equal_to(5) }
      it { is_expected.to validate_comparison_of(:maximum_age).is_greater_than_or_equal_to(:minimum_age) }
    end

    context "when horse type is stallion" do
      subject(:config) { build(:auction_consignment_config, :stallion) }

      it { is_expected.to validate_numericality_of(:minimum_age).is_greater_than_or_equal_to(4).is_less_than_or_equal_to(12) }
      it { is_expected.to validate_numericality_of(:maximum_age).is_greater_than_or_equal_to(5).is_less_than_or_equal_to(15) }
      it { is_expected.to validate_comparison_of(:maximum_age).is_greater_than_or_equal_to(:minimum_age) }
    end

    context "when horse type is broodmare" do
      subject(:config) { build(:auction_consignment_config, :broodmare) }

      it { is_expected.to validate_numericality_of(:minimum_age).is_greater_than_or_equal_to(4).is_less_than_or_equal_to(12) }
      it { is_expected.to validate_numericality_of(:maximum_age).is_greater_than_or_equal_to(5).is_less_than_or_equal_to(15) }
      it { is_expected.to validate_comparison_of(:maximum_age).is_greater_than_or_equal_to(:minimum_age) }
    end

    context "when horse type is yearling" do
      subject(:config) { build(:auction_consignment_config, :yearling) }

      it { is_expected.to validate_numericality_of(:minimum_age).is_equal_to(1) }
      it { is_expected.to validate_numericality_of(:maximum_age).is_equal_to(1) }
      it { is_expected.to validate_comparison_of(:maximum_age).is_greater_than_or_equal_to(:minimum_age) }
    end

    context "when horse type is weanling" do
      subject(:config) { build(:auction_consignment_config, :weanling) }

      it { is_expected.to validate_numericality_of(:minimum_age).is_equal_to(0) }
      it { is_expected.to validate_numericality_of(:maximum_age).is_equal_to(0) }
      it { is_expected.to validate_comparison_of(:maximum_age).is_greater_than_or_equal_to(:minimum_age) }
    end
  end
end

