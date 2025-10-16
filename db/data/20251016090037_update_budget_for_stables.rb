class UpdateBudgetForStables < ActiveRecord::Migration[8.0]
  def up
    Account::Stable.find_each do |stable|
      legacy_budget = Legacy::Budget.where(ID: stable.legacy_id).order(Date: :desc, ID: :desc).first
      next unless legacy_budget

      new_budget = Account::Budget.where(stable:).order(created_at: :desc).first

      amount = legacy_budget.Balance - new_budget.balance
      if amount.positive?
        Account::Budget.create_new(stable:, description: "Budget adjustment", amount:)
      end
      legacy_stable = Legacy::Stable.find_by(id: stable.legacy_id)
      if legacy_stable.availableBalance < legacy_stable.totalBalance
        available_amount = legacy_stable.availableBalance - legacy_stable.totalBalance
      end
      stable.update(total_balance: amount, available_balance: amount + available_amount)
    end
  end

  def down
    # rubocop:disable Rails/SkipsModelValidations
    Account::Stable.update_all(total_balance: nil, available_balance: nil)
    # rubocop:enable Rails/SkipsModelValidations
  end
end

