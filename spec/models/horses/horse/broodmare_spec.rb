RSpec.describe Horses::Horse::Broodmare do
  describe "associations" do
    subject(:horse) { build_stubbed(:broodmare) }

    it { is_expected.to have_many(:foals).class_name("Horses::Horse").inverse_of(:dam).dependent(:nullify) }
    it { is_expected.to have_one(:foal_record).inverse_of(:mare) }
  end
end

