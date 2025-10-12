class MigrateLegacyBudgetsService # rubocop:disable Metrics/ClassLength
  attr_reader :budget_id, :limit

  def initialize(budget_id:, limit: 50)
    @budget_id = budget_id
    @limit = limit
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    Legacy::Budget.where("ID > ?", budget_id).order(ID: :asc).limit(limit).find_each do |budget|
      next if Account::Budget.exists?(legacy_budget_id: budget.ID)

      stable = Account::Stable.find_by(legacy_id: budget.Stable)
      budget_attrs = {
        stable:,
        description: budget.Description,
        amount: budget.Amount,
        date: Date.parse(budget.Date.to_s) - 4.years,
        legacy_budget_id: budget.ID,
        legacy_stable_id: budget.Stable
      }
      if Account::Budget.exists?(stable:)
        Account::Budget.create_new(**budget_attrs)
      else
        budget_attrs[:balance] = budget.Amount
        budget_attrs[:created_at] = budget_attrs.delete(:date)
        Account::Budget.create!(budget_attrs)
      end
    end
  rescue => e
    Rails.logger.error "Info: #{e.message}"
    raise e
  end
end

