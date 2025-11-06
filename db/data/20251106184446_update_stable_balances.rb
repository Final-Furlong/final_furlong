class UpdateStableBalances < ActiveRecord::Migration[8.1]
  def up
    stable_balances.each do |stable_info|
      stable = Account::Stable.find_by(legacy_id: stable_info[:legacy_id])
      next unless stable

      Accounts::BudgetTransactionCreator.new.create_transaction(
        stable:,
        description: "Budget adjustment",
        amount: stable_info[:amount],
        activity_type: nil,
        increment_available_balance: false
      )
    end

    Account::Stable.find_each do |stable|
      budget = Account::Budget.where(stable:).recent.first
      next unless budget

      total_balance = budget.balance
      stable.update_columns(available_balance: total_balance, total_balance:) # rubocop:disable Rails/SkipsModelValidations
    end
    Horses::Boarding.current.find_each do |boarding|
      days = (Date.current - boarding.start_date).to_i
      stable = boarding.horse.owner

      stable.available_balance -= days * Horses::Boarding::DAILY_BOARDING_FEE
      stable.save(validate: false)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def stable_balances
    [
      { legacy_id: 3505, amount: 3261239 },
      { legacy_id: 4089, amount: 1751 },
      { legacy_id: 4084, amount: 10303771 },
      { legacy_id: 2783, amount: 340015 },
      { legacy_id: 133, amount: 4522813 }
    ]
  end
end

