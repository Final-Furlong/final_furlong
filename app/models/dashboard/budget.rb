module Dashboard
  class Budget
    include Pagy::Method

    attr_reader :query, :transactions, :pagy, :total_positive, :total_negative, :total_diff

    def initialize(query:, transactions:, pagy:, query_result:)
      @query = query
      @query_result = query_result
      @total_positive = @query_result.credit.sum(:amount)
      @total_negative = @query_result.debit.sum(:amount)
      @total_diff = @total_positive - @total_negative.abs
      @transactions = transactions
      @pagy = pagy
    end

    def categories
      Config::Budgets.dashboard_activity_types.map { |type| [I18n.t("current_stable.budgets.index.category.#{type}"), type] }
    end
  end
end

