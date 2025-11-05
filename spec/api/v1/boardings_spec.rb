RSpec.describe Api::V1::Boardings do
  describe "POST /api/v1/boardings" do
    before do
      horse
      racetrack
      legacy_racetrack
    end

    context "when boarding creation works" do
      it "returns boarding ID" do
        post("/api/v1/boardings", params:)

        expect(response).to have_http_status :created
        expect(json_body).to eq({ boarding_id: Horses::Boarding.order(id: :asc).last.id })
      end

      it "creates boarding" do
        expect { post("/api/v1/boardings", params:) }.to change(Horses::Boarding, :count).by(1)
      end

      it "sets correct data on boarding" do
        post("/api/v1/boardings", params:)

        expect(Horses::Boarding.count).to eq 1
        expect(Horses::Boarding.order(id: :asc).last).to have_attributes(
          horse:,
          location:,
          start_date: Date.current,
          end_date: nil,
          days: 0
        )
      end
    end

    context "when horse cannot be found" do
      it "returns error" do
        post("/api/v1/boardings", params: params.merge(legacy_horse_id: -1))

        expect(response).to have_http_status :not_found
        expect(json_body[:error]).to include("Couldn't find Horses::Horse")
      end

      it "does not create boarding" do
        expect do
          post("/api/v1/boardings", params: params.merge(legacy_horse_id: -1))
        end.not_to change(Horses::Boarding, :count)
      end
    end

    context "when legacy racetrack cannot be found" do
      it "returns error" do
        post("/api/v1/boardings", params: params.merge(legacy_racetrack_id: -1))

        expect(response).to have_http_status :not_found
        expect(json_body[:error]).to include("Couldn't find Legacy::Racetrack")
      end

      it "does not create boarding" do
        expect do
          post("/api/v1/boardings", params: params.merge(legacy_racetrack_id: -1))
        end.not_to change(Horses::Boarding, :count)
      end
    end

    context "when boarding creation fails" do
      it "returns error" do
        mock_creator = instance_double(Horses::BoardingCreator)
        allow(Horses::BoardingCreator).to receive(:new).and_return mock_creator
        allow(mock_creator).to receive(:start_boarding).and_raise ActiveRecord::RecordNotSaved
        post("/api/v1/boardings", params:)

        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe "PUT /api/v1/boardings/:id" do
    before do
      boarding
    end

    context "when boarding has not ended" do
      it "ends boarding" do
        expect do
          put "/api/v1/boardings/#{boarding.id}"
        end.not_to change(Horses::Boarding, :count)
        expect(boarding.reload.end_date).to eq Date.current
      end

      it "returns completed" do
        put "/api/v1/boardings/#{boarding.id}"

        expect(response).to have_http_status :ok
        expect(json_body).to eq({ completed: true })
      end
    end

    context "when boarding has already ended" do
      it "does not update boarding" do
        boarding.update(start_date: 2.days.ago, end_date: 1.day.ago)

        expect do
          put "/api/v1/boardings/#{boarding.id}"
        end.not_to change(boarding, :reload)
      end

      it "returns error" do
        boarding.update(start_date: 2.days.ago, end_date: 1.day.ago)

        put "/api/v1/boardings/#{boarding.id}"

        expect(response).to have_http_status :internal_server_error
        expect(json_body[:detail]).to eq I18n.t("services.boarding.completion.already_ended")
      end
    end
  end

  describe "DELETE /api/v1/boardings" do
    before do
      boarding
    end

    context "when boarding has started today" do
      it "deletes boarding" do
        expect do
          delete "/api/v1/boardings/#{boarding.id}"
        end.to change(Horses::Boarding, :count).by(-1)
      end

      it "returns deleted" do
        delete "/api/v1/boardings/#{boarding.id}"

        expect(response).to have_http_status :ok
        expect(json_body).to eq({ deleted: true })
      end
    end

    context "when boarding has started before today" do
      it "does not delete boarding" do
        boarding.update(start_date: 1.day.ago)

        expect do
          delete "/api/v1/boardings/#{boarding.id}"
        end.not_to change(Horses::Boarding, :count)
      end

      it "returns error" do
        boarding.update(start_date: 1.day.ago)

        delete "/api/v1/boardings/#{boarding.id}"

        expect(response).to have_http_status :internal_server_error
        expect(json_body[:detail]).to eq I18n.t("services.boarding.deletion.in_progress")
      end
    end
  end

  private

  def params
    {
      legacy_horse_id: legacy_horse.ID,
      legacy_racetrack_id: legacy_racetrack.ID
    }
  end

  def boarding
    @boarding ||= create(:boarding, horse:, start_date: Date.current)
  end

  def horse
    @horse ||= create(:horse, legacy_id: legacy_horse.ID)
  end

  def legacy_horse
    @legacy_horse ||= create(:legacy_horse)
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
end

