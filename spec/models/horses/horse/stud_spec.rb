RSpec.describe Horses::Horse::Stud do
  describe "associations" do
    subject(:stud) { build(:horse, :stallion).stud }

    it "has a foal record" do
      expect(stud.record).to have_one(:stud_foal_record)
    end
  end

  describe "#breed_ranking_string" do
    it "delegates to foal record" do
      stud = create(:horse, :stud).stud
      record = Horses::StudFoalRecord.create(stud: stud.record)
      allow(record).to receive(:breed_ranking_string).and_call_original
      stud.breed_ranking_string
      expect(record).to have_received(:breed_ranking_string)
    end
  end
end

