RSpec.describe Stable, type: :model do
  describe "associations" do
    subject(:stable) { described_class.new }

    it { is_expected.to belong_to :user }

    it "owns horses" do
      expect(stable).to have_many(:horses).inverse_of(:owner)
    end

    it "breeds horses" do
      expect(stable).to have_many(:bred_horses).inverse_of(:breeder)
    end
  end
end
