RSpec.describe Horses::BoardingCreator do
  shared_examples "an unprocessed boarding" do
    it "does not create boarding" do
      expect { described_class.new.start_boarding(horse:, legacy_racetrack:) }.not_to change(Horses::Boarding, :count)
    end

    it "returns error" do
      result = described_class.new.start_boarding(horse:, legacy_racetrack:)
      expect(result.created?).to be false
      expect(result.error).to eq message
    end
  end

  describe "#start_boarding" do
    before { racetrack }

    context "when legacy racetrack does not map to a location" do
      it_behaves_like "an unprocessed boarding" do
        before { racetrack.update(name: SecureRandom.alphanumeric(20)) }

        let(:message) { error("location_not_found") }
      end
    end

    context "when location is not flagged with has_farm" do
      it_behaves_like "an unprocessed boarding" do
        before { racetrack.location.update(has_farm: false) }

        let(:message) { error("invalid_location") }
      end
    end

    context "when horse is not a racehorse" do
      it_behaves_like "an unprocessed boarding" do
        let(:horse) { create(:horse, :broodmare) }
        let(:message) { error("horse_not_racehorse") }
      end
    end

    context "when horse currently being boarded" do
      it_behaves_like "an unprocessed boarding" do
        before { create(:boarding, :current, horse:) }

        let(:message) { error("horse_currently_boarded") }
      end
    end

    context "when horse has reached max boarding limit for the year" do
      context "with single boarding record" do
        it_behaves_like "an unprocessed boarding" do
          before do
            travel_to Date.new(Date.current.year, 3, 1)
            create(:boarding, :current, horse:, location:, start_date: Date.current - 40.days, end_date: Date.current - 10.days)
          end

          let(:message) { error("max_days_reached") }
        end
      end

      context "with multiple boarding records" do
        it_behaves_like "an unprocessed boarding" do
          before do
            travel_to Date.new(Date.current.year, 3, 1)
            create(:boarding, :current, horse:, location:, start_date: Date.current - 40.days, end_date: Date.current - 25.days)
            create(:boarding, :current, horse:, location:, start_date: Date.current - 25.days, end_date: Date.current - 10.days)
          end

          let(:message) { error("max_days_reached") }
        end
      end

      context "with multiple boarding records crossing year boundaries" do
        it_behaves_like "an unprocessed boarding" do
          before do
            travel_to Date.new(Date.current.year, 3, 1)
            dec_20 = Date.new(Date.current.year - 1, 12, 20)
            create(:boarding, :current, horse:, location:, start_date: dec_20, end_date: dec_20 + 30.days)
            create(:boarding, :current, horse:, location:, start_date: Date.current - 25.days, end_date: Date.current - 6.days)
          end

          let(:message) { error("max_days_reached") }
        end
      end
    end

    context "when horse has been boarded elsewhere for max days" do
      it "allows booking" do
        travel_to Date.new(Date.current.year, 3, 1) do
          create(:boarding, :current, horse:, start_date: Date.current - 40.days, end_date: Date.current - 10.days)
          expect { described_class.new.start_boarding(horse:, legacy_racetrack:) }.to change(Horses::Boarding, :count).by(1)
        end
      end
    end

    context "when horse has historical boarding for max days in a previous year" do
      it "allows booking" do
        travel_to Date.new(Date.current.year, 3, 1) do
          start_date = Date.current - 1.year
          create(:boarding, horse:, start_date:, end_date: start_date + 30.days)
          expect { described_class.new.start_boarding(horse:, legacy_racetrack:) }.to change(Horses::Boarding, :count).by(1)
        end
      end
    end

    context "when horse no historical boarding" do
      it "allows booking" do
        expect do
          result = described_class.new.start_boarding(horse:, legacy_racetrack:)
          expect(result.created?).to be true
          expect(result.boarding).to be_a Horses::Boarding
          expect(result.boarding).to have_attributes(horse:, location:, start_date: Date.current, days: 0)
        end.to change(Horses::Boarding, :count).by(1)
      end
    end

    context "when boarding creation fails" do
      it "allows booking" do
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(Horses::Boarding).to receive(:save!).and_return false
        result = described_class.new.start_boarding(horse:, legacy_racetrack:)
        expect(result.created?).to be false
        expect(result.boarding).to be_a Horses::Boarding
        # rubocop:enable RSpec/AnyInstance
      end
    end
  end

  private

  def horse
    @horse ||= create(:horse)
  end

  def legacy_racetrack
    @legacy_racetrack ||= create(:legacy_racetrack)
  end

  def racetrack
    @racetrack ||= create(:racetrack, name: legacy_racetrack.Name)
  end

  def location
    @location ||= racetrack.location
  end

  def error(key)
    I18n.t("services.boarding.creator.#{key}")
  end
end

