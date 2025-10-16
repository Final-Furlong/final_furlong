module Accounts
  class BudgetTransactionCreator < ApplicationService
    def create_transaction(stable:, description:, amount:, date:, legacy_budget_id: nil, legacy_stable_id: nil)
      previous_budget = Account::Budget.where(stable:).recent.last
      attrs = {
        stable:,
        description:,
        amount:,
        balance: (previous_budget&.balance || 0) + amount
      }
      attrs[:created_at] = date if date.present?
      attrs[:legacy_budget_id] = legacy_budget_id if legacy_budget_id.present?
      attrs[:legacy_stable_id] = legacy_stable_id if legacy_stable_id.present?
      ActiveRecord::Base.transaction do
        new_budget = Account::Budget.create!(attrs)
        stable.total_balance += amount
        stable.available_balance += amount
        stable.save!

        new_budget
      end
    end
  end
end

