RSpec.describe Horses::Horse::Stud do
  describe "associations" do
    subject(:stud) { build(:horse, :stallion).stud }

    it "has a foal record" do
      expect(stud.record).to have_one(:stud_foal_record)
    end
  end
end

