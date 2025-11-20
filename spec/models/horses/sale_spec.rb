RSpec.describe Horses::Sale do
  describe "associations" do
    it { is_expected.to belong_to(:horse) }
    it { is_expected.to belong_to(:seller).class_name("Account::Stable") }
    it { is_expected.to belong_to(:buyer).class_name("Account::Stable") }
  end

  describe "validations" do
    subject(:sale) { build(:horse_sale) }

    it { is_expected.to validate_presence_of(:date) }

    describe "seller/buyer" do
      it "is invalid if both are the same" do
        original_buyer = sale.buyer
        sale.buyer = sale.seller
        expect(sale).not_to be_valid
        expect(sale.errors[:buyer]).to eq(["cannot be the same as the owner"])

        sale.buyer = original_buyer
        expect(sale).to be_valid
      end
    end
  end
end

