class UniqueIndexes < ActiveRecord::Migration[7.0]
  def change
    remove_index :users, :discourse_id
    remove_index :users, :email
    remove_index :users, :reset_password_token
    remove_index :users, :unlock_token
    remove_index :users, :username
    remove_index :users, :confirmation_token

    add_index :users, :discourse_id, unique: true
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :unlock_token, unique: true
    add_index :users, :username, unique: true
    add_index :users, :confirmation_token, unique: true
  end
end
