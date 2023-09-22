RSpec.describe Account::Stable do
  describe "associations" do
    subject(:stable) { described_class.new }

    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:horses).class_name("Horses::Horse").inverse_of(:owner) }
    it { is_expected.to have_many(:bred_horses).class_name("Horses::Horse").inverse_of(:breeder) }
    it { is_expected.to have_many(:training_schedules).class_name("Racing::TrainingSchedule").inverse_of(:stable) }
  end
end

