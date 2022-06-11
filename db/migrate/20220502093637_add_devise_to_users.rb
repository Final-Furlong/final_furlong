# typed: false
class AddDeviseToUsers < ActiveRecord::Migration[7.0]
  def self.up
    remove_index :users, :email
    remove_column :users, :email, :string

    change_table :users, bulk: true do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end

  def self.down
    remove_index :users, :email,                unique: true
    remove_index :users, :reset_password_token, unique: true
    remove_index :users, :confirmation_token,   unique: true
    remove_index :users, :unlock_token,         unique: true

    change_table :users, bulk: true do |t|
      ## Database authenticatable
      t.string :email, null: false, default: ""
      t.remove :encrypted_password, null: false, default: ""

      ## Recoverable
      t.remove :reset_password_token, comment: "devise recoverable"
      t.remove :reset_password_sent_at, comment: "devise recoverable"

      ## Rememberable
      t.remove :remember_created_at, comment: "devise rememberable"

      ## Trackable
      t.remove :sign_in_count, default: 0, null: false, comment: "devise trackable"
      t.remove :current_sign_in_at, comment: "devise trackable"
      t.remove :last_sign_in_at, comment: "devise trackable"
      t.remove :current_sign_in_ip, comment: "devise trackable"
      t.remove :last_sign_in_ip, comment: "devise trackable"

      ## Confirmable
      t.remove :confirmation_token, comment: "devise confirmable"
      t.remove :confirmed_at, comment: "devise confirmable"
      t.remove :confirmation_sent_at, comment: "devise confirmable"
      t.remove :unconfirmed_email, comment: "devise reconfirmable" # Only if using reconfirmable

      ## Lockable
      t.remove :failed_attempts, default: 0, null: false, comment: "devise lockable (lock strategy: failed_attempts)" # Only if lock strategy is :failed_attempts
      t.remove :unlock_token, comment: "devise lockable (unlock strategy: email / both)" # Only if unlock strategy is :email or :both
      t.remove :locked_at, comment: "devise lockable"
    end

    add_index :users, :email, unique: true
  end
end
