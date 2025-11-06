RSpec.describe Api::V1::Budgets do
  describe "POST /api/v1/budgets" do
    context "when budget creation works" do
      it "returns budget ID" do
        initial_budget

        post("/api/v1/budgets", params:)

        expect(response).to have_http_status :created
        expect(json_body).to eq({ budget_id: Account::Budget.recent.first.id })
      end

      it "creates budget" do
        initial_budget

        expect { post("/api/v1/budgets", params:) }.to change(Account::Budget, :count).by(1)
      end

      it "sets correct data on budget" do
        initial_budget

        post("/api/v1/budgets", params:)

        expect(Account::Budget.count).to eq 2
        expect(Account::Budget.recent.first).to have_attributes(
          stable:,
          amount: -5000,
          balance: 245_000,
          description: params[:description],
          legacy_stable_id: params[:legacy_stable_id]
        )
      end
    end

    context "when budget amount is positive" do
      it "returns budget ID" do
        initial_budget

        post("/api/v1/budgets", params: params.merge(amount: 10_000))

        expect(response).to have_http_status :created
        expect(json_body).to eq({ budget_id: Account::Budget.recent.first.id })
      end

      it "creates budget" do
        initial_budget

        expect { post("/api/v1/budgets", params: params.merge(amount: 10_000)) }.to change(Account::Budget, :count).by(1)
      end

      it "sets correct data on budget" do
        initial_budget

        post("/api/v1/budgets", params: params.merge(amount: 10_000))

        expect(Account::Budget.recent.first).to have_attributes(
          stable:,
          amount: 10_000,
          balance: 260_000,
          description: params[:description],
          legacy_stable_id: params[:legacy_stable_id]
        )
      end
    end

    context "when stable cannot be found" do
      it "returns error" do
        post("/api/v1/budgets", params: params.merge(legacy_stable_id: 25))

        expect(response).to have_http_status :not_found
        expect(json_body[:error]).to include("Couldn't find Account::Stable")
      end

      it "does not create budget" do
        expect do
          post("/api/v1/budgets", params: params.merge(legacy_stable_id: 15))
        end.not_to change(Account::Budget, :count)
      end
    end

    context "when budget creation fails" do
      it "returns error" do
        mock_creator = instance_double(Accounts::BudgetTransactionCreator)
        allow(Accounts::BudgetTransactionCreator).to receive(:new).and_return mock_creator
        allow(mock_creator).to receive(:create_transaction).and_raise ActiveRecord::RecordNotSaved
        post("/api/v1/budgets", params:)

        expect(response).to have_http_status :unprocessable_entity
      end

      it "does not create budget" do
        mock_creator = instance_double(Accounts::BudgetTransactionCreator)
        allow(Accounts::BudgetTransactionCreator).to receive(:new).and_return mock_creator
        allow(mock_creator).to receive(:create_transaction).and_raise ActiveRecord::RecordNotSaved
        expect do
          post("/api/v1/budgets", params:)
        end.not_to change(Account::Budget, :count)
      end
    end
  end

  private

  def params
    {
      amount: -5000,
      description: "Bought a horse",
      legacy_stable_id: stable.legacy_id
    }
  end

  def stable
    @stable ||= create(:stable, legacy_id: 1)
  end

  def initial_budget
    @initial_budget ||= Account::Budget.create(stable:, created_at: 1.day.ago, description: "Opening Balance", amount: 250_000, balance: 250_000)
  end
end

