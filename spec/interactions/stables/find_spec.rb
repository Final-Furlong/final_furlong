RSpec.describe Stables::Find do
  describe "#run" do
    context "when given a non-string id" do
      it "returns error" do
        outcome = described_class.run(id: ["1", "2"])

        expect(outcome).not_to be_valid
        expect(outcome.errors.messages).to eq({ id: ["is not a valid integer"] })
      end
    end

    context "when stable exists" do
      it "returns stable" do
        stable = create(:stable)

        outcome = described_class.run(id: stable.id)
        expect(outcome.result).to eq stable
      end
    end

    context "when stable does not exist" do
      it "returns stable" do
        outcome = described_class.run(id: -1)
        expect(outcome).not_to be_valid
        expect(outcome.errors.messages).to eq({ id: ["does not exist"] })
      end
    end
  end
end

