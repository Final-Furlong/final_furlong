RSpec.describe RacehorsesRelation do
  describe "#gateway" do
    it "is default" do
      expect(described_class.gateway).to eq :default
    end
  end
end

