class DeleteRaceRecords < ActiveRecord::Migration[8.1]
  def change
    drop_table :race_records, force: :cascade # rubocop:disable Rails/ReversibleMigration
    create_view :race_records, materialized: true
  end
end

