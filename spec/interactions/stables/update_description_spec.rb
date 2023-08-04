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
          outcome = described_class.run(stable: stable, description: 'hi, <a href="#">click here</a>')
          expect(outcome).to be_valid
        end.to change(stable.reload, :description).to("hi, click here")
      end
    end

    context "when description is valid" do
      it "updates stable description" do
        stable = create(:stable, description: "")
        expect do
          outcome = described_class.run(stable: stable, description: "hi, <em>cool stable</em>")
          expect(outcome).to be_valid
        end.to change(stable.reload, :description).to("hi, <em>cool stable</em>")
      end

      it "updates legacy stable description" do
        legacy_user = create(:legacy_user)
        stable = create(:stable, description: "", legacy_id: legacy_user.id)
        expect do
          outcome = described_class.run(stable: stable, description: "hi, <em>cool stable</em>")
          expect(outcome).to be_valid
        end.to change { legacy_user.reload.description }.to("hi, cool stable")
      end
    end
  end
end

