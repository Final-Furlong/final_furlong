RSpec.describe Api::V1::Activity do
  describe "POST /api/v1/activity" do
    context "when activity creation works" do
      it "returns activity ID" do
        initial_activity

        post("/api/v1/activity", params:)

        expect(response).to have_http_status :created
        expect(json_body).to eq({ activity_id: Account::Activity.recent.first.id })
      end

      it "creates activity" do
        initial_activity

        expect { post("/api/v1/activity", params:) }.to change(Account::Activity, :count).by(1)
      end

      it "sets correct data on activity" do
        initial_activity

        post("/api/v1/activity", params:)

        expect(Account::Activity.count).to eq 3
        expect(Account::Activity.recent.first).to have_attributes(
          stable:,
          amount: 5,
          balance: 15
        )
      end
    end

    context "when activity amount is negative" do
      it "returns activity ID" do
        initial_activity

        post("/api/v1/activity", params: params.merge(amount: -5, activity_type: "redeem"))

        expect(response).to have_http_status :created
        expect(json_body).to eq({ activity_id: Account::Activity.recent.first.id })
      end

      it "creates activity" do
        initial_activity

        expect do
          post("/api/v1/activity", params: params.merge(amount: -5, activity_type: "redeem"))
        end.to change(Account::Activity, :count).by(1)
      end

      it "sets correct data on activity" do
        initial_activity

        post("/api/v1/activity", params: params.merge(amount: -5, activity_type: "redeem"))

        expect(Account::Activity.recent.first).to have_attributes(
          stable:,
          amount: -5,
          balance: 5
        )
      end
    end

    context "when stable cannot be found" do
      it "returns error" do
        params = { amount: 5, activity_type: "color_war", legacy_stable_id: 25 }
        post("/api/v1/activity", params:)

        expect(response).to have_http_status :not_found
        expect(json_body[:error]).to include("Couldn't find Account::Stable")
      end

      it "does not create activity" do
        params = { amount: 5, activity_type: "color_war", legacy_stable_id: 25 }
        expect do
          post("/api/v1/activity", params:)
        end.not_to change(Account::Activity, :count)
      end
    end

    context "when activity creation fails" do
      it "returns error" do
        mock_creator = instance_double(Accounts::ActivityTransactionCreator)
        allow(Accounts::ActivityTransactionCreator).to receive(:new).and_return mock_creator
        allow(mock_creator).to receive(:create_transaction).and_raise ActiveRecord::RecordNotSaved
        post("/api/v1/activity", params:)

        expect(response).to have_http_status :unprocessable_entity
      end

      it "does not create activity" do
        mock_creator = instance_double(Accounts::ActivityTransactionCreator)
        allow(Accounts::ActivityTransactionCreator).to receive(:new).and_return mock_creator
        allow(mock_creator).to receive(:create_transaction).and_raise ActiveRecord::RecordNotSaved
        expect do
          post("/api/v1/activity", params:)
        end.not_to change(Account::Activity, :count)
      end
    end
  end

  private

  def params
    {
      amount: 5,
      activity_type: "color_war",
      legacy_stable_id: stable.legacy_id
    }
  end

  def stable
    @stable ||= create(:stable, legacy_id: 1)
  end

  def initial_activity
    @initial_activity ||= create(:activity, stable:, amount: 5, activity_type: activity_type.activity_type)
  end

  def activity_type
    @activity_type ||= Game::Activity.create!(
      activity_type: "color_war",
      first_year_points: 5,
      second_year_points: 2,
      older_year_points: 0
    )
  end
end

