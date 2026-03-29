class RemoveExtraIndexes < ActiveRecord::Migration[8.1]
  def change
    remove_index :activity_points, :stable_id, if_exists: true
    remove_index :budget_transactions, :legacy_stable_id, if_exists: true
    remove_index :budget_transactions, :stable_id, if_exists: true
    remove_index :horses, :owner_id, if_exists: true
    remove_index :horses, :status, if_exists: true
  end
end

