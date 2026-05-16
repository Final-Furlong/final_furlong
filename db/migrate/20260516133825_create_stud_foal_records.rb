class CreateStudFoalRecords < ActiveRecord::Migration[8.1]
  def change
    # rubocop:disable Rails/ReversibleMigration
    drop_table :stud_foal_records, if_exists: true
    # rubocop:enable Rails/ReversibleMigration
    create_view :stud_foal_records, materialized: true
  end
end

