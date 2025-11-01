class AddDiscardedIndexesToNewUsers < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    remove_index :new_users, :admin if index_exists?(:new_users, :admin)
    add_index :new_users, :admin, where: "(discarded_at IS NOT NULL)", algorithm: :concurrently

    remove_index :new_users, :developer if index_exists?(:new_users, :developer)
    add_index :new_users, :developer, where: "(discarded_at IS NOT NULL)", algorithm: :concurrently

    remove_index :new_users, :discourse_id if index_exists?(:new_users, :discourse_id)
    add_index :new_users, :discourse_id, where: "(discarded_at IS NOT NULL)", unique: true, algorithm: :concurrently

    remove_index :new_users, :email if index_exists?(:new_users, :email)
    add_index :new_users, :email, where: "(discarded_at IS NOT NULL)", unique: true, algorithm: :concurrently

    remove_index :new_users, :name if index_exists?(:new_users, :name)
    add_index :new_users, :name, where: "(discarded_at IS NOT NULL)", algorithm: :concurrently

    remove_index :new_users, :public_id if index_exists?(:new_users, :public_id)
    add_index :new_users, :public_id, where: "(discarded_at IS NOT NULL)", unique: true, algorithm: :concurrently

    remove_index :new_users, :slug if index_exists?(:new_users, :slug)
    add_index :new_users, :slug, where: "(discarded_at IS NOT NULL)", unique: true, algorithm: :concurrently

    remove_index :new_users, :username if index_exists?(:new_users, :username)
    add_index :new_users, :username, where: "(discarded_at IS NOT NULL)", unique: true, algorithm: :concurrently
  end
end

