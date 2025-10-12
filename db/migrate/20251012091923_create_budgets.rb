class CreateBudgets < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    create_table :budgets, id: :uuid do |t|
      t.references :stable, type: :uuid, foreign_key: { to_table: :stables }, null: false
      t.text :description, null: false, index: { algorithm: :concurrently }
      t.integer :amount, default: 0, null: false
      t.integer :balance, default: 0, null: false
      t.integer :legacy_budget_id, default: 0, index: { algorithm: :concurrently }
      t.integer :legacy_stable_id, default: 0, index: { algorithm: :concurrently }

      t.timestamps
    end
  end
end

