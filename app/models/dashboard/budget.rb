module Dashboard
  class Budget
    include Pagy::Method

    attr_reader :query, :transactions, :pagy, :total_positive, :total_negative, :total_diff

    DEFAULT_SORT = "created_at desc".freeze
    ACTIVITY_TYPES = %w[
      sold_or_bought sold_horse bought_horse leased_horse claimed_horse consigned_auction
      boarded_horse
      all_breeding bred_mare bred_stud
      all_racing entered_race shipped_horse race_winnings jockey_fee
      all_nominations nominated_racehorse nominated_stallion nominated_breeders_series
      game_activity color_war activity_points donation
      misc
    ].freeze

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
      ACTIVITY_TYPES.map { |type| [I18n.t("current_stable.budgets.index.category.#{type}"), type] }
    end
  end
end

