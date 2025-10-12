class AddDeveloperFlagToUser < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_column :users, :developer, :boolean, default: false, null: false

    add_index :users, :developer, where: "(discarded_at IS NULL)", algorithm: :concurrently
  end
end

