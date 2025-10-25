RSpec.describe Api::V1::RaceResults do
  describe "POST /api/v1/race_results" do
    context "when race result creation works" do
      it "returns race result ID" do
        mock_result = Racing::RaceResultCreator::Result.new(created: true, race_result:)
        mock_creator = instance_double(Racing::RaceResultCreator, create_result: mock_result)
        allow(Racing::RaceResultCreator).to receive(:new).and_return mock_creator

        post("/api/v1/race_results", params:)

        expect(response).to have_http_status :created
        expect(json_body).to eq({ race_result_id: mock_result.race_result.id })
      end
    end

    context "when race result creation works but result is nil" do
      it "returns result ID nil" do
        mock_result = Racing::RaceResultCreator::Result.new(created: true, race_result: nil)
        mock_creator = instance_double(Racing::RaceResultCreator, create_result: mock_result)
        allow(Racing::RaceResultCreator).to receive(:new).and_return mock_creator

        post("/api/v1/race_results", params:)

        expect(response).to have_http_status :created
        expect(json_body).to eq({ race_result_id: nil })
      end
    end

    context "when race result creation fails" do
      it "returns error" do
        error = SecureRandom.alphanumeric(20)
        mock_result = Racing::RaceResultCreator::Result.new(created: false, race_result:, error:)
        mock_creator = instance_double(Racing::RaceResultCreator, create_result: mock_result)
        allow(Racing::RaceResultCreator).to receive(:new).and_return mock_creator

        post("/api/v1/race_results", params:)

        expect(response).to have_http_status :internal_server_error
        expect(json_body).to eq({ error: "invalid", detail: error })
      end
    end
  end

  private

  def params
    @params ||= {
      date: Date.current.to_s,
      number: 1,
      race_type: "maiden",
      distance: 9.0,
      age: "3",
      track_name: racetrack.name,
      track_surface: surface.surface,
      condition: "good",
      time: 81.0,
      purse: 20_000,
      horses: [
        {
          finish_position: 1,
          post_parade: 1,
          positions: "1|1|1",
          margins: "1|1|1",
          fractions: "1|1|1",
          legacy_id: horse1.legacy_id,
          jockey_legacy_id: jockey1.legacy_id,
          odds: "10:1",
          weight: 100,
          speed_factor: 100,
          blinkers: true,
          figure_8: true
        },
        {
          finish_position: 2,
          post_parade: 2,
          positions: "2|2|2",
          margins: "2|2|2",
          fractions: "2|2|2",
          legacy_id: horse2.legacy_id,
          jockey_legacy_id: jockey2.legacy_id,
          odds: "20:1",
          weight: 110,
          speed_factor: 90,
          wraps: true
        }
      ]
    }
  end

  def race_result
    @race_result ||= create(:race_result)
  end

  def racetrack
    @racetrack ||= create(:racetrack)
  end

  def surface
    @surface ||= create(:track_surface, racetrack:)
  end

  def horse1
    @horse1 ||= create(:horse, legacy_id: 1)
  end

  def jockey1
    @jockey1 ||= create(:jockey, legacy_id: 2)
  end

  def jockey2
    @jockey2 ||= create(:jockey, legacy_id: 3)
  end

  def horse2
    @horse2 ||= create(:horse, legacy_id: 4)
  end
end

