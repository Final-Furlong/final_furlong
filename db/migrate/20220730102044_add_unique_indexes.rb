class AddUniqueIndexes < ActiveRecord::Migration[7.0]
  def change
    remove_index :stables, :user_id
    add_index :stables, :user_id, unique: true

    remove_index :activations, :user_id
    add_index :activations, :user_id, unique: true
  end
end
