RSpec.describe Horses::Horse::Broodmare do
  describe "associations" do
    subject(:broodmare) { build(:horse, :broodmare).broodmare }

    it "has a foal record" do
      expect(broodmare.record).to have_one(:broodmare_foal_record)
    end
  end

  describe "#breed_ranking_string" do
    it "delegates to foal record" do
      broodmare = create(:horse, :broodmare).broodmare
      record = Horses::BroodmareFoalRecord.create(mare: broodmare.record)
      allow(record).to receive(:breed_ranking_string).and_call_original
      broodmare.breed_ranking_string
      expect(record).to have_received(:breed_ranking_string)
    end
  end

  describe "#current_location" do
    context "when mare has no shipments" do
      context "when mare is leased" do
        it "return leaser" do
          broodmare = create(:horse, :broodmare).broodmare
          lease = create(:lease, horse: broodmare.record)
          expect(broodmare.current_location).to eq lease.leaser
        end
      end

      context "when mare is not leased" do
        it "return owner" do
          broodmare = create(:horse, :broodmare).broodmare
          expect(broodmare.current_location).to eq broodmare.record.owner
        end
      end
    end

    context "when mare has past shipments" do
      it "returns last shipment ending farm" do
        broodmare = create(:horse, :broodmare).broodmare
        shipment = create(:broodmare_shipment, horse: broodmare.record)
        expect(broodmare.current_location).to eq shipment.ending_farm
      end
    end

    context "when mare has future shipments" do
      it "returns owner" do
        broodmare = create(:horse, :broodmare).broodmare
        create(:broodmare_shipment, horse: broodmare.record,
          departure_date: Date.current + 1.day)
        expect(broodmare.current_location).to eq broodmare.record.owner
      end
    end
  end

  describe "#current_location_name" do
    context "when mare has no shipments" do
      context "when mare is leased" do
        it "return leaser" do
          broodmare = create(:horse, :broodmare).broodmare
          lease = create(:lease, horse: broodmare.record)
          expect(broodmare.current_location_name).to eq lease.leaser.name
        end
      end

      context "when mare is not leased" do
        it "return owner" do
          broodmare = create(:horse, :broodmare).broodmare
          expect(broodmare.current_location_name).to eq broodmare.record.owner.name
        end
      end
    end

    context "when mare has past shipments" do
      it "returns last shipment ending farm" do
        broodmare = create(:horse, :broodmare).broodmare
        shipment = create(:broodmare_shipment, horse: broodmare.record)
        expect(broodmare.current_location_name).to eq shipment.ending_farm.name
      end
    end

    context "when mare has future shipments" do
      it "returns owner" do
        broodmare = create(:horse, :broodmare).broodmare
        create(:broodmare_shipment, horse: broodmare.record,
          departure_date: Date.current + 1.day)
        expect(broodmare.current_location_name).to eq broodmare.record.owner.name
      end
    end
  end

  describe "#in_transit?" do
    context "when mare has no shipments" do
      it "return false" do
        broodmare = create(:horse, :broodmare).broodmare
        expect(broodmare.in_transit?).to be false
      end
    end

    context "when mare has past shipments" do
      context "when all shipments have ended" do
        it "returns false" do
          broodmare = create(:horse, :broodmare).broodmare
          shipment = create(:broodmare_shipment, horse: broodmare.record)
          shipment.update_columns(
            departure_date: Date.current - 5.days,
            arrival_date: Date.current - 1.day
          )
          expect(broodmare.in_transit?).to be false
        end
      end

      context "when a shipment has not ended" do
        it "returns false" do
          broodmare = create(:horse, :broodmare).broodmare
          create(:broodmare_shipment, horse: broodmare.record,
            departure_date: Date.current,
            arrival_date: Date.current + 1.day)
          expect(broodmare.in_transit?).to be true
        end
      end
    end

    context "when mare has future shipments" do
      it "returns owner" do
        broodmare = create(:horse, :broodmare).broodmare
        create(:broodmare_shipment, horse: broodmare.record,
          departure_date: Date.current + 1.day)
        expect(broodmare.in_transit?).to be false
      end
    end
  end
end

