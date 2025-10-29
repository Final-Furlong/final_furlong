RSpec.describe Racing::AnnualRaceRecord do
  describe "associations" do
    it { is_expected.to belong_to(:horse).class_name("Horses::Horse").inverse_of(:annual_race_records) }
  end
end

