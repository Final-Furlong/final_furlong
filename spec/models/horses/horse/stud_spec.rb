RSpec.describe Horses::Horse::Stud do
  describe "associations" do
    subject(:horse) { build_stubbed(:stallion) }

    it { is_expected.to have_many(:foals).class_name("Horses::Horse").inverse_of(:sire).dependent(:nullify) }
    it { is_expected.to have_one(:foal_record).inverse_of(:stud) }
  end
end

