RSpec.describe Account::Stable do
  describe "associations" do
    subject(:stable) { described_class.new }

    it { is_expected.to belong_to :user }

    it "owns horses" do
      expect(stable).to have_many(:horses).class_name("Horses::Horse").inverse_of(:owner)
    end

    it "breeds horses" do
      expect(stable).to have_many(:bred_horses).class_name("Horses::Horse").inverse_of(:breeder)
    end
  end
end

