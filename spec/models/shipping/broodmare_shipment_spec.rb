RSpec.describe Shipping::BroodmareShipment do
  describe "associations" do
    it { is_expected.to belong_to(:horse).class_name("Horses::Horse") }
    it { is_expected.to belong_to(:starting_farm).class_name("Account::Stable") }
    it { is_expected.to belong_to(:ending_farm).class_name("Account::Stable") }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:departure_date) }
    it { is_expected.to validate_presence_of(:arrival_date) }
    it { is_expected.to validate_presence_of(:mode) }
    it { is_expected.to validate_presence_of(:starting_farm) }
    it { is_expected.to validate_presence_of(:ending_farm) }
    it { is_expected.to validate_inclusion_of(:mode).in_array(Shipping::Route::MODES) }

    describe "departure date" do
      it "can be the current date" do
        shipment = build(:broodmare_shipment, departure_date: Date.current)
        expect(shipment).to be_valid
      end

      it "can be a future date" do
        shipment = build(:broodmare_shipment, departure_date: Date.current + 1.day)
        expect(shipment).to be_valid
      end

      it "cannot be a past date" do
        shipment = create(:broodmare_shipment, :past)
        expect(shipment).not_to be_valid
        expect(shipment.errors[:departure_date]).to eq(["must be greater than or equal to #{l(Date.current)}"])
      end

      it "cannot be too far in the future" do
        max_date = Date.current + described_class::MAX_DELAYED_SHIPMENT_DAYS.days
        shipment = build(:broodmare_shipment, departure_date: max_date + 1.day)
        expect(shipment).not_to be_valid
        expect(shipment.errors[:departure_date]).to eq(["must be less than or equal to #{l(max_date)}"])
      end
    end

    describe "arrival date" do
      it "cannot be less than departure date" do
        shipment = build(:broodmare_shipment, departure_date: Date.current,
          arrival_date: Date.current - 1.day)
        expect(shipment).not_to be_valid
        expect(shipment.errors[:arrival_date]).to eq(["must be greater than #{l(Date.current)}"])
      end

      it "can be greater than departure date" do
        shipment = build(:broodmare_shipment, departure_date: Date.current, arrival_date: Date.current + 1.day)
        expect(shipment).to be_valid
      end
    end

    describe "ending farm" do
      it "cannot be the same as starting farm" do
        shipment = build(:broodmare_shipment)
        shipment.ending_farm = shipment.starting_farm
        expect(shipment).not_to be_valid
        expect(shipment.errors[:ending_farm]).to eq(["cannot be the same as the starting farm"])
      end
    end
  end

  describe "scopes" do
    describe ".current" do
      it "returns the correct records" do
        today_shipment = create(:broodmare_shipment)
        past_shipment = create(:broodmare_shipment, :past)
        future_shipment = create(:broodmare_shipment, departure_date: Date.current + 1.day, arrival_date: Date.current + 3.days)

        result = described_class.current
        expect(result).to include today_shipment, past_shipment
        expect(result).not_to include future_shipment
      end
    end

    describe ".future" do
      it "returns the correct records" do
        today_shipment = create(:broodmare_shipment, departure_date: Date.current, arrival_date: Date.current + 1.day)
        past_shipment = create(:broodmare_shipment, :past)
        future_shipment = create(:broodmare_shipment, departure_date: Date.current + 1.day, arrival_date: Date.current + 3.days)

        result = described_class.future
        expect(result).to include future_shipment
        expect(result).not_to include today_shipment, past_shipment
      end
    end
  end

  describe "#future?" do
    context "when departure date is in the past" do
      it "returns false" do
        past_shipment = create(:broodmare_shipment, :past)
        expect(past_shipment.future?).to be false
      end
    end

    context "when departure data is today" do
      it "returns false" do
        today_shipment = create(:broodmare_shipment, departure_date: Date.current, arrival_date: Date.current + 1.day)
        expect(today_shipment.future?).to be false
      end
    end

    context "when departure date is in the future" do
      it "returns true" do
        future_shipment = create(:broodmare_shipment, departure_date: Date.current + 1.day, arrival_date: Date.current + 3.days)
        expect(future_shipment.future?).to be true
      end
    end
  end

  describe "#maximum_departure_date" do
    it "returns correct date" do
      shipment = build(:broodmare_shipment)
      expect(shipment.maximum_departure_date).to eq Date.current + 60.days
    end
  end

  describe "#options_for_mode_select" do
    it "returns correct array" do
      shipment = build(:broodmare_shipment)
      expect(shipment.options_for_mode_select).to eq([
        [I18n.t("horse.shipments.form.mode_road"), "road"],
        [I18n.t("horse.shipments.form.mode_air"), "air"]
      ])
    end
  end

  describe "#options_for_destination_select" do
    it "returns correct array" do
      stable_with_1_stud = create(:stable, name: "C Stable")
      create(:horse, :stallion, owner: stable_with_1_stud)

      stable_with_2_studs = create(:stable, name: "B Stable")
      create_list(:horse, 2, :stallion, owner: stable_with_2_studs)

      stable_with_leased_stud = create(:stable, name: "D Stable")
      leased_stud = create(:horse, :stallion, owner: stable_with_leased_stud)
      leaser = create(:stable, name: "A Stable")
      create(:lease, horse: leased_stud, leaser:)

      shipment = build(:broodmare_shipment)
      expect(shipment.options_for_destination_select).to eq([
        [leaser.name, leaser.id],
        [stable_with_2_studs.name, stable_with_2_studs.id],
        [stable_with_1_stud.name, stable_with_1_stud.id]
      ])
    end
  end
end

