RSpec.describe Racing::Odd do
  describe "associations" do
    it { is_expected.to have_many(:race_result_horses).class_name("Racing::RaceResultHorse").inverse_of(:odd) }
  end
end

