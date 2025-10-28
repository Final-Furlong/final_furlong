class DropNewTables < ActiveRecord::Migration[8.0]
  def change
    # rubocop:disable Rails/ReversibleMigration
    drop_table :new_horses if table_exists? :new_horses
    drop_table :new_users if table_exists? :new_users
    # rubocop:enable Rails/ReversibleMigration
  end
end

