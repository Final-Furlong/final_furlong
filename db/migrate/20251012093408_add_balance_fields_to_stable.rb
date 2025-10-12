class AddBalanceFieldsToStable < ActiveRecord::Migration[8.0]
  def change
    add_column :stables, :available_balance, :integer, default: 0
    add_column :stables, :total_balance, :integer, default: 0
  end
end

