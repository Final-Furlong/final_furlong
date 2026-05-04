RSpec.describe Stables::UpdateDescription do
  describe "#run" do
    context "when stable is invalid" do
      it "raises error" do
        outcome = described_class.run(stable: [1, 2], description: "foo")

        expect(outcome).not_to be_valid
        expect(outcome.errors.messages).to eq({ stable: ["is not a valid object"] })
      end
    end

    context "when description is not a string" do
      it "raises error" do
        outcome = described_class.run(stable: build(:stable), description: [1, 2])

        expect(outcome).not_to be_valid
        expect(outcome.errors.messages).to eq({ description: ["is not a valid string"] })
      end
    end

    context "when description is too long" do
      it "returns error" do
        outcome = described_class.run(stable: build(:stable), description: "a" * 1001)

        expect(outcome).not_to be_valid
        expect(outcome.errors.messages).to eq({ description: ["is too long (maximum is 1000 characters)"] })
      end
    end

    context "when description contains invalid html" do
      it "strips invalid html" do
        stable = create(:stable, description: "")
        expect do
          outcome = described_class.run(stable:, description: 'hi, <a href="#">click here</a>')
          expect(outcome).to be_valid
        end.to change(stable.reload, :description).to("hi, click here")
      end
    end

    context "when description is valid" do
      it "updates stable description" do
        stable = create(:stable, description: "")
        expect do
          outcome = described_class.run(stable:, description: "hi, <em>cool stable</em>")
          expect(outcome).to be_valid
        end.to change(stable.reload, :description).to("hi, <em>cool stable</em>")
      end
    end
  end
end

