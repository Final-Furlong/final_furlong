class AddOldIdToNewUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :new_users, :old_id, :string
    add_index :new_users, :old_id, unique: true
  end
end
