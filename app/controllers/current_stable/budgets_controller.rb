module CurrentStable
  class BudgetsController < AuthenticatedController
    def index
      query = policy_scope(Account::Budget).ransack(params[:q])
      query.sorts = Dashboard::Budget::DEFAULT_SORT if query.sorts.blank?
      pagy, transactions = pagy(:offset, query.result)

      @dashboard = Dashboard::Budget.new(query:, transactions:, pagy:, query_result: query.result)
    end
  end
end

