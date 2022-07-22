class AddDatabaseIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :horses, :date_of_birth
    add_index :horses, :status

    add_index :racetracks, :name
    add_index :racetracks, :country
    add_index :racetracks, :latitude
    add_index :racetracks, :longitude

    add_index :stables, :legacy_id

    rename_column :users, :new_username, :username
    add_index :users, :confirmation_token
    add_index :users, :discarded_at
    add_index :users, :email
    add_index :users, :reset_password_token
    add_index :users, :username
    add_index :users, :unlock_token
    add_index :users, :discourse_id
  end
end
