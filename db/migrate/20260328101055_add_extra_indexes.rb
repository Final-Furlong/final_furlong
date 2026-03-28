class AddExtraIndexes < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :leases, %i[horse_id active], algorithm: :concurrently
    add_index :horses, %i[owner_id status], algorithm: :concurrently
    add_index :horses, %i[status name], algorithm: :concurrently
    add_index :racing_stats, :natural_energy_current, algorithm: :concurrently
    add_index :budget_transactions, %i[stable_id created_at], algorithm: :concurrently
    add_index :budget_transactions, %i[legacy_stable_id created_at], algorithm: :concurrently
    add_index :activity_points, %i[stable_id created_at], algorithm: :concurrently
  end
end

