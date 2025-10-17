class UpdateBudgetsToUseBigInt < ActiveRecord::Migration[8.0]
  def change
    safety_assured do
      change_column :budgets, :amount, :bigint
      change_column :budgets, :balance, :bigint
    end
  end
end

