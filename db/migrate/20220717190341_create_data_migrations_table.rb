class CreateDataMigrationsTable < ActiveRecord::Migration[7.0]
  def up
    return if ActiveRecord::Base.connection.table_exists? "data_migrations"

    # rubocop:disable Rails/CreateTableWithTimestamps:
    create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
      # nil
    end
    # rubocop:enable Rails/CreateTableWithTimestamps:
  end

  def down
    migrations = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM data_migrations").first
    drop_table "data_migrations" if migrations["count"].to_i.zero?
  end
end

