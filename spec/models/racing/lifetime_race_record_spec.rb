RSpec.describe Racing::LifetimeRaceRecord do
  describe "associations" do
    it { is_expected.to belong_to(:horse).class_name("Horses::Horse").inverse_of(:lifetime_race_record) }
  end
end

