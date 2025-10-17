class UpdateBudgetsToUseBigInt < ActiveRecord::Migration[8.0]
  def change
    # rubocop:disable Rails/ReversibleMigration
    safety_assured do
      change_column :budgets, :amount, :bigint
      change_column :budgets, :balance, :bigint
    end
    # rubocop:enable Rails/ReversibleMigration
  end
end

