RSpec.describe Racing::EquipmentStatusGenerator do
  describe "#call" do
    context "when the horse has extra equipment it does not want" do
      it "hates it" do
        generator = described_class.new(current_equipment: [:wraps, :blinkers], desired_equipment: [:wraps])
        expect(generator.call).to eq(described_class::HATE)
      end
    end

    context "when the horse is missing the equipment it wants" do
      it "dislikes it" do
        generator = described_class.new(current_equipment: [:blinkers], desired_equipment: [:wraps, :blinkers])
        expect(generator.call).to eq(described_class::DISLIKE)
      end
    end

    context "when the horse has the right equipment" do
      it "loves it" do
        generator = described_class.new(current_equipment: [:wraps, :blinkers], desired_equipment: [:wraps, :blinkers])
        expect(generator.call).to eq(described_class::LOVE)
      end
    end

    context "when the horse has no equipment and wants none" do
      it "loves it" do
        generator = described_class.new(current_equipment: [], desired_equipment: [])
        expect(generator.call).to eq(described_class::LOVE)
      end
    end
  end
end

