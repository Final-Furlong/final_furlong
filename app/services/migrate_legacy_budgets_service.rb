class MigrateLegacyBudgetsService # rubocop:disable Metrics/ClassLength
  attr_reader :budget_id, :limit

  def initialize(budget_id:, limit: 50)
    @budget_id = budget_id
    @limit = limit
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    Legacy::Budget.where("ID > ?", budget_id).order(Date: :asc, ID: :asc).limit(limit).find_each do |legacy_budget|
      next if Account::Budget.exists?(legacy_budget_id: legacy_budget.ID)

      stable = Account::Stable.find_by(legacy_id: legacy_budget.Stable)
      budget_attrs = {
        stable:,
        description: legacy_budget.Description,
        amount: legacy_budget.Amount,
        date: Date.parse(legacy_budget.Date.to_s) - 4.years,
        legacy_budget_id: legacy_budget.ID,
        legacy_stable_id: legacy_budget.Stable
      }
      if Account::Budget.exists?(stable:)
        Account::Budget.create_new(**budget_attrs)
      else
        budget_attrs[:balance] = legacy_budget.Amount
        budget_attrs[:created_at] = budget_attrs.delete(:date)
        Account::Budget.create!(budget_attrs)
      end
    end
  rescue => e
    Rails.logger.error "Info: #{e.message}"
    raise e
  end
end

