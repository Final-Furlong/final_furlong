class UpdateUsersTable < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      remove_column :users, :encrypted_password, :string, default: "", null: false, if_exists: true
      remove_column :users, :reset_password_sent_at, :datetime, if_exists: true
      remove_column :users, :reset_password_token, :string, if_exists: true
      remove_column :users, :unlock_token, :string, if_exists: true
    end

    remove_index :users, :email, if_exists: true

    add_index :users, 'LOWER(email)', name: 'index_users_on_email', unique: true, where: '(discarded_at IS NULL)', algorithm: :concurrently
  end
end
