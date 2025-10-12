class UpdateLegacyBudgetsJob < ApplicationJob
  queue_as :low_priority

  def perform
    budget_id = Account::Budget.maximum(:legacy_budget_id) || 0
    MigrateLegacyBudgetsService.new(budget_id:, limit: 1000).call
  end
end

