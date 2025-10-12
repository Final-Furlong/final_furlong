module Api
  module V1
    class Budgets < Grape::API
      include Api::V1::Defaults

      resource :budgets do
        desc "Create a budget entry for a stable"
        params do
          requires :amount, type: Integer, desc: "Amount of the transaction"
          requires :description, type: String, desc: "Description of the transaction"
          requires :legacy_stable_id, type: Integer, desc: "Legacy ID for the stable"
          optional :legacy_budget_id, type: Integer, desc: "Unique ID for the Legacy::Budget entry"
        end
        post "/" do
          stable = Account::Stable.find_by!(legacy_id: params[:legacy_stable_id])
          attrs = {
            stable:,
            description: params[:description],
            amount: params[:amount],
            date: Date.current,
            legacy_stable_id: params[:legacy_stable_id]
          }
          attrs[:legacy_budget_id] = params[:legacy_budget_id] if params[:legacy_budget_id].present?
          budget = Accounts::BudgetTransactionCreator.new.create_transaction(**attrs)
          error!({ error: "invalid", detail: budget.errors.full_messages.to_sentence }, 500) unless budget

          { budget_id: budget.id }
        end
      end
    end
  end
end

