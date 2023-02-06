RSpec.describe Account::StableDescriptionContract do
  let(:result) { subject.call(attributes) }

  context "when a description is provided" do
    let(:attributes) { { description: "Test Stable" } }

    it "is valid" do
      expect(result).to be_success
    end
  end

  context "when a description is empty" do
    let(:attributes) { { description: nil } }

    it "is not valid" do
      expect(result).to be_failure

      expect(result.errors[:description]).to eq(["must be filled"])
    end
  end

  context "when a description is missing" do
    let(:attributes) { {} }

    it "is not valid" do
      expect(result).to be_failure

      expect(result.errors[:description]).to eq(["is missing"])
    end
  end
end

