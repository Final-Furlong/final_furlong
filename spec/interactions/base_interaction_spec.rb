RSpec.describe BaseInteraction do
  describe "#execute" do
    it "raises error" do
      expect { described_class.new.execute }.to raise_error NotImplementedError, "#execute must be defined in BaseInteraction"
    end
  end
end

