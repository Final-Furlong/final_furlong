class CreateBroodmareFoalRecords < ActiveRecord::Migration[8.1]
  def change
    # rubocop:disable Rails/ReversibleMigration
    drop_table :broodmare_foal_records, if_exists: true
    # rubocop:enable Rails/ReversibleMigration
    create_view :broodmare_foal_records, materialized: true
  end
end

