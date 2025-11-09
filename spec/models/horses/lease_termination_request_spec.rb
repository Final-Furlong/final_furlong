RSpec.describe Horses::LeaseTerminationRequest do
  describe "associations" do
    it { is_expected.to belong_to(:lease).class_name("Horses::Lease") }
  end

  describe "validations" do
    describe "owner accepted end" do
      it "can be false when not in owner update context" do
        request = described_class.new(lease:, owner_accepted_end: false)
        expect(request).to be_valid
      end

      it "cannot be false when in owner update context" do
        request = described_class.new(lease:, owner_accepted_end: false)
        expect(request.valid?(:owner_update)).to be false
      end

      it "can be true when in owner update context" do
        request = described_class.new(lease:, owner_accepted_end: true)
        expect(request.valid?(:owner_update)).to be true
      end
    end

    describe "leaser accepted end" do
      it "can be false when not in leaser update context" do
        request = described_class.new(lease:, leaser_accepted_end: false)
        expect(request).to be_valid
      end

      it "cannot be false when in leaser update context" do
        request = described_class.new(lease:, leaser_accepted_end: false)
        expect(request.valid?(:leaser_update)).to be false
      end

      it "can be true when in leaser update context" do
        request = described_class.new(lease:, leaser_accepted_end: true)
        expect(request.valid?(:leaser_update)).to be true
      end
    end
  end

  describe "#both_sides_accept?" do
    context "when owner accepted & leaser accepted are true" do
      it "returns true" do
        request = described_class.new(owner_accepted_end: true, leaser_accepted_end: true)

        expect(request.both_sides_accept?).to be true
      end
    end

    context "when owner accepted is false & leaser accepted is true" do
      it "returns false" do
        request = described_class.new(owner_accepted_end: false, leaser_accepted_end: true)

        expect(request.both_sides_accept?).to be false
      end
    end

    context "when owner accepted is true & leaser accepted is false" do
      it "returns false" do
        request = described_class.new(owner_accepted_end: true, leaser_accepted_end: false)

        expect(request.both_sides_accept?).to be false
      end
    end
  end

  describe "#both_sides_accept_refund?" do
    context "when owner accepted & leaser accepted are true" do
      it "returns true" do
        request = described_class.new(owner_accepted_refund: true, leaser_accepted_refund: true)

        expect(request.both_sides_accept_refund?).to be true
      end
    end

    context "when owner accepted is false & leaser accepted is true" do
      it "returns false" do
        request = described_class.new(owner_accepted_refund: false, leaser_accepted_refund: true)

        expect(request.both_sides_accept_refund?).to be false
      end
    end

    context "when owner accepted is true & leaser accepted is false" do
      it "returns false" do
        request = described_class.new(owner_accepted_refund: true, leaser_accepted_refund: false)

        expect(request.both_sides_accept_refund?).to be false
      end
    end
  end

  private

  def lease
    @lease ||= build_stubbed(:lease)
  end
end

