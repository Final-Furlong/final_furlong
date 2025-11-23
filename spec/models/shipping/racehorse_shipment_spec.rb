RSpec.describe Shipping::RacehorseShipment do
  describe "associations" do
    it { is_expected.to belong_to(:horse).class_name("Horses::Horse") }
    it { is_expected.to belong_to(:starting_location).class_name("Location") }
    it { is_expected.to belong_to(:ending_location).class_name("Location") }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:departure_date) }
    it { is_expected.to validate_presence_of(:arrival_date) }
    it { is_expected.to validate_presence_of(:mode) }
    it { is_expected.to validate_presence_of(:shipping_type) }
    it { is_expected.to validate_inclusion_of(:mode).in_array(Shipping::Route::MODES) }

    describe "departure date" do
      it "can be the current date" do
        shipment = build(:racehorse_shipment, departure_date: Date.current)
        expect(shipment).to be_valid
      end

      it "can be a future date" do
        shipment = build(:racehorse_shipment, departure_date: Date.current + 1.day)
        expect(shipment).to be_valid
      end

      it "cannot be a past date" do
        shipment = create(:racehorse_shipment, :past)
        expect(shipment).not_to be_valid
        expect(shipment.errors[:departure_date]).to eq(["must be greater than or equal to #{l(Date.current)}"])
      end

      it "cannot be too far in the future" do
        max_date = Date.current + described_class::MAX_DELAYED_SHIPMENT_DAYS.days
        shipment = build(:racehorse_shipment, departure_date: max_date + 1.day)
        expect(shipment).not_to be_valid
        expect(shipment.errors[:departure_date]).to eq(["must be less than or equal to #{l(max_date)}"])
      end
    end

    describe "arrival date" do
      it "cannot be less than departure date" do
        shipment = build(:racehorse_shipment, departure_date: Date.current,
          arrival_date: Date.current - 1.day)
        expect(shipment).not_to be_valid
        expect(shipment.errors[:arrival_date]).to eq(["must be greater than #{l(Date.current)}"])
      end

      it "can be greater than departure date" do
        shipment = build(:racehorse_shipment, departure_date: Date.current, arrival_date: Date.current + 1.day)
        expect(shipment).to be_valid
      end
    end
  end

  describe "scopes" do
    describe ".current" do
      it "returns the correct records" do
        today_shipment = create(:racehorse_shipment)
        past_shipment = create(:racehorse_shipment, :past)
        future_shipment = create(:racehorse_shipment, departure_date: Date.current + 1.day, arrival_date: Date.current + 3.days)

        result = described_class.current
        expect(result).to include today_shipment, past_shipment
        expect(result).not_to include future_shipment
      end
    end

    describe ".future" do
      it "returns the correct records" do
        today_shipment = create(:racehorse_shipment, departure_date: Date.current, arrival_date: Date.current + 1.day)
        past_shipment = create(:racehorse_shipment, :past)
        future_shipment = create(:racehorse_shipment, departure_date: Date.current + 1.day, arrival_date: Date.current + 3.days)

        result = described_class.future
        expect(result).to include future_shipment
        expect(result).not_to include today_shipment, past_shipment
      end
    end
  end

  describe "#future?" do
    context "when departure date is in the past" do
      it "returns false" do
        past_shipment = create(:racehorse_shipment, :past)
        expect(past_shipment.future?).to be false
      end
    end

    context "when departure data is today" do
      it "returns false" do
        today_shipment = create(:racehorse_shipment, departure_date: Date.current, arrival_date: Date.current + 1.day)
        expect(today_shipment.future?).to be false
      end
    end

    context "when departure date is in the future" do
      it "returns true" do
        future_shipment = create(:racehorse_shipment, departure_date: Date.current + 1.day, arrival_date: Date.current + 3.days)
        expect(future_shipment.future?).to be true
      end
    end
  end

  describe "#maximum_departure_date" do
    it "returns correct date" do
      shipment = build(:racehorse_shipment)
      expect(shipment.maximum_departure_date).to eq Date.current + 60.days
    end
  end

  describe "#options_for_mode_select" do
    it "returns correct array" do
      shipment = build(:racehorse_shipment)
      expect(shipment.options_for_mode_select).to eq([
        [I18n.t("horse.shipments.form.mode_road"), "road"],
        [I18n.t("horse.shipments.form.mode_air"), "air"]
      ])
    end
  end

  describe "#options_for_destination_select" do
    context "when horse is at the farm" do
      it "excludes current track as a location" do
        horse = create(:horse, :racehorse)
        shipment = create(:racehorse_shipment, :past, horse:, shipping_type: "track_to_farm")
        location = create(:location)
        racetrack = create(:racetrack, location:)

        expect(shipment.options_for_destination_select(horse)).to eq([
          [racetrack.name, location.id]
        ])
      end
    end

    context "when horse is not at the farm" do
      it "includes farm as a destination" do
        horse = create(:horse, :racehorse)
        owner = horse.owner
        shipment = create(:racehorse_shipment, :past, horse:, shipping_type: "track_to_track")
        location = create(:location)
        racetrack = create(:racetrack, location:)
        owner_location = create(:location)
        racetrack2 = create(:racetrack, location: owner_location)
        owner.update(racetrack: racetrack2)

        expect(shipment.options_for_destination_select(horse)).to include(
          [racetrack.name, location.id],
          [owner.name, "Farm"]
        )
      end
    end
  end
end

