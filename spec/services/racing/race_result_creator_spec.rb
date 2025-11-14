RSpec.describe Racing::RaceResultCreator do
  context "when all info is provided" do
    context "with a single horse" do
      it "returns creates true" do
        new_params = params.dup
        new_params[:horses] = horses.slice(0, 1)
        result = described_class.new.create_result(**new_params)
        expect(result.created?).to be true
      end

      it "creates race result" do
        new_params = params.dup
        new_params[:horses] = horses.slice(0, 1)
        expect do
          described_class.new.create_result(**new_params)
        end.to change(Racing::RaceResult, :count).by(1)
      end

      it "creates race result horse" do
        new_params = params.dup
        new_params[:horses] = horses.slice(0, 1)
        expect do
          described_class.new.create_result(**new_params)
        end.to change(Racing::RaceResultHorse, :count).by(1)
      end

      it "triggers horse attribute job" do
        new_params = params.dup
        new_params[:horses] = horses.slice(0, 1)
        described_class.new.create_result(**new_params)

        expect(Horses::UpdateHorseAttributesJob).to have_been_enqueued.with(horse1)
      end
    end

    context "with multiple horses" do
      it "returns creates true" do
        result = described_class.new.create_result(**params)
        expect(result.created?).to be true
      end

      it "creates race result" do
        expect do
          described_class.new.create_result(**params)
        end.to change(Racing::RaceResult, :count).by(1)
      end

      it "creates race result horses" do
        expect do
          described_class.new.create_result(**params)
        end.to change(Racing::RaceResultHorse, :count).by(2)
      end

      it "triggers horse attributes job for each horse" do
        described_class.new.create_result(**params)

        expect(Horses::UpdateHorseAttributesJob).to have_been_enqueued.with(horse1)
        expect(Horses::UpdateHorseAttributesJob).to have_been_enqueued.with(horse2)
      end
    end

    context "with stakes race" do
      it "returns creates true" do
        new_params = params.merge(grade: "Grade 3", name: "Christmas Stakes")
        result = described_class.new.create_result(**new_params)
        expect(result.created?).to be true
      end

      it "creates race result" do
        new_params = params.merge(grade: "Grade 3", name: "Christmas Stakes")
        expect do
          described_class.new.create_result(**new_params)
        end.to change(Racing::RaceResult, :count).by(1)
      end

      it "creates race result horses" do
        new_params = params.merge(grade: "Grade 3", name: "Christmas Stakes")
        expect do
          described_class.new.create_result(**new_params)
        end.to change(Racing::RaceResultHorse, :count).by(2)
      end
    end

    context "with claiming race" do
      it "returns creates true" do
        new_params = params.merge(race_type: "claiming", claiming_price: 10_000)
        result = described_class.new.create_result(**new_params)
        expect(result.created?).to be true
      end

      it "creates race result" do
        new_params = params.merge(race_type: "claiming", claiming_price: 10_000)
        expect do
          described_class.new.create_result(**new_params)
        end.to change(Racing::RaceResult, :count).by(1)
      end

      it "creates race result horses" do
        new_params = params.merge(race_type: "claiming", claiming_price: 10_000)
        expect do
          described_class.new.create_result(**new_params)
        end.to change(Racing::RaceResultHorse, :count).by(2)
      end
    end
  end

  context "when info is invalid for the race" do
    it "returns creates false" do
      new_params = params.dup
      new_params[:distance] = 0.1
      result = described_class.new.create_result(**new_params)
      expect(result.created?).to be false
    end

    it "returns error" do
      new_params = params.dup
      new_params[:distance] = 0.1
      result = described_class.new.create_result(**new_params)
      expect(result.error).to eq "Validation failed: Distance must be greater than or equal to 5.0"
    end

    it "does not create race result" do
      new_params = params.dup
      new_params[:distance] = 0.1
      expect do
        described_class.new.create_result(**new_params)
      end.not_to change(Racing::RaceResult, :count)
    end

    it "creates race result horse" do
      new_params = params.dup
      new_params[:distance] = 0.1
      expect do
        described_class.new.create_result(**new_params)
      end.not_to change(Racing::RaceResultHorse, :count)
    end
  end

  context "when info is invalid for the horse" do
    it "returns creates false" do
      new_params = params.dup
      new_params[:horses][0][:post_parade] = 20
      result = described_class.new.create_result(**new_params)
      expect(result.created?).to be false
    end

    it "returns error" do
      new_params = params.dup
      new_params[:horses][1][:post_parade] = 20
      result = described_class.new.create_result(**new_params)
      expect(result.error).to eq "Validation failed: Post parade must be less than or equal to 14"
    end

    it "does not create race result" do
      new_params = params.dup
      new_params[:horses][1][:post_parade] = 20
      expect do
        described_class.new.create_result(**new_params)
      end.not_to change(Racing::RaceResult, :count)
    end

    it "creates race result horse" do
      new_params = params.dup
      new_params[:horses][1][:post_parade] = 20
      expect do
        described_class.new.create_result(**new_params)
      end.not_to change(Racing::RaceResultHorse, :count)
    end
  end

  private

  def params
    {
      date: Date.current,
      number: 1,
      race_type: "maiden",
      distance: 10.5,
      age: "3",
      surface:,
      condition: "fast",
      time: 75.2,
      purse: 15_000,
      horses:
    }
  end

  def surface
    @surface ||= create(:track_surface)
  end

  def horses
    @horses ||= [
      {
        finish_position: 1,
        post_parade: 2,
        positions: "2|2|2|2|1",
        margins: "1|1|1|1|Head",
        fractions: "0:10|0:20|0:30|0:40|0:50",
        legacy_id: horse1.legacy_id,
        jockey_legacy_id: jockey1.legacy_id,
        odds: "20:1",
        weight: 125,
        speed_factor: 95,
        blinkers: true
      },
      {
        finish_position: 2,
        post_parade: 1,
        positions: "1|1|1|1|2",
        margins: "1|1|1|1|Head",
        fractions: "0:10|0:20|0:30|0:40|0:50",
        legacy_id: horse2.legacy_id,
        jockey_legacy_id: jockey2.legacy_id,
        odds: "10:1",
        weight: 125,
        speed_factor: 91
      }
    ]
  end

  def horse1
    @horse1 ||= create(:horse, legacy_id: 10)
  end

  def horse2
    @horse2 ||= create(:horse, legacy_id: 20)
  end

  def jockey1
    @jockey1 ||= create(:jockey, legacy_id: 1)
  end

  def jockey2
    @jockey2 ||= create(:jockey, legacy_id: 2)
  end
end

