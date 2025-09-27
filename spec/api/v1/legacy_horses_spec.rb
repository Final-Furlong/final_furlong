require "rails_helper"

RSpec.describe Api::V1::LegacyHorses do
  describe "POST /api/v1/legacy_horses" do
    context "when ID does not match a legacy horse" do
      it "returns an error" do
        post "/api/v1/legacy_horses", params: { id: 123 }

        expect(response).to have_http_status :not_found
        expect(json_body[:error]).to include "Couldn't find Legacy::Horse"
      end
    end

    context "when ID does match a legacy horse" do
      before do
        allow(MigrateLegacyHorseService).to receive(:new).and_return mock_horse_migration
      end

      context "when Horses::Horse matches legacy horse" do
        it "returns rails ID" do
          horse = create(:horse, legacy_id: legacy_horse.ID)
          post "/api/v1/legacy_horses", params: { id: legacy_horse.ID }

          expect(response).to have_http_status :created
          expect(json_body).to eq({ rails_id: horse.id })
        end
      end

      context "when Horses::Horse does not match legacy horse" do
        it "returns rails ID" do
          allow(mock_horse_migration).to receive(:call).and_return true
          horse = create(:horse)
          allow(Horses::Horse).to receive(:find_by).and_return horse
          post "/api/v1/legacy_horses", params: { id: legacy_horse.ID }

          expect(response).to have_http_status :created
          expect(json_body).to eq({ rails_id: horse.id })
          expect(mock_horse_migration).to have_received(:call)
        end

        context "when migration errors" do
          it "returns rails ID" do
            allow(mock_horse_migration).to receive(:call).and_return false
            post "/api/v1/legacy_horses", params: { id: legacy_horse.ID }

            expect(response).to have_http_status :internal_server_error
            expect(json_body).to eq({ error: "invalid", detail: "Failed to migrate horse with ID #{legacy_horse.ID}" })
            expect(mock_horse_migration).to have_received(:call)
          end
        end

        context "when post-migration horse fetching errors" do
          it "returns rails ID" do
            allow(mock_horse_migration).to receive(:call).and_return true
            allow(Horses::Horse).to receive(:find_by).and_return nil
            post "/api/v1/legacy_horses", params: { id: legacy_horse.ID }

            expect(response).to have_http_status :internal_server_error
            expect(json_body).to eq({ error: "not_found", detail: "Failed to migrate horse with ID #{legacy_horse.ID}" })
            expect(mock_horse_migration).to have_received(:call)
          end
        end
      end
    end
  end

  private

  def mock_horse_migration
    @mock_horse_migration ||= instance_double(MigrateLegacyHorseService, call: true)
  end

  def legacy_horse
    @legacy_horse ||= create(:legacy_horse, last_synced_to_rails_at: 5.minutes.ago)
  end
end

