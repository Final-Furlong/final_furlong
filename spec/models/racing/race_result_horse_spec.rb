RSpec.describe Racing::RaceResultHorse do
  describe "associations" do
    it { is_expected.to belong_to(:race).class_name("Racing::RaceResult").inverse_of(:horses) }
    it { is_expected.to belong_to(:horse).class_name("Horses::Horse").inverse_of(:race_result_finishes) }
    it { is_expected.to belong_to(:jockey).class_name("Racing::Jockey").inverse_of(:race_result_horses) }
    it { is_expected.to belong_to(:odd).class_name("Racing::Odd").inverse_of(:race_result_horses) }
  end
end

