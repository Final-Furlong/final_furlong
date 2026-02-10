module CurrentStable
  class BudgetsController < AuthenticatedController
    def index
      query = policy_scope(Account::Budget).ransack(params[:q])
      query.sorts = Config::Budgets.default_sort if query.sorts.blank?
      pagy, transactions = pagy(:offset, query.result)

      @dashboard = Dashboard::Budget.new(query:, transactions:, pagy:, query_result: query.result)
    end
  end
end

