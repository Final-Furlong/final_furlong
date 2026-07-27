class DeleteDataMigrationsTable < ActiveRecord::Migration[8.1]
  def change
    drop_table :data_migrations # rubocop:disable Rails/ReversibleMigration
  end
end

