RSpec.describe Account::UpdateStable do
  subject(:operation) { described_class.new }

  describe "validating" do
    context "when validation is successful" do
      it "returns the stable parameters" do
        input = { description: "Test Stable" }

        result = operation.validate(input)
        expect(result).to be_success
        expect(result.value!.to_h).to eq(input)
      end
    end

    context "when validation fails" do
      it "returns validation errors" do
        input = {}

        result = operation.validate(input)
        expect(result).to be_failure
        expect(result.failure.errors[:description]).to eq(["is missing"])
      end
    end
  end
end

