class CreateBreedings < ActiveRecord::Migration[8.1]
  def change
    create_enum :breeding_statuses, Config::Breedings.statuses
    create_table :breedings do |t|
      t.references :mare, type: :bigint, index: false, foreign_key: { to_table: :horses }
      t.references :stud, type: :bigint, null: false, index: true, foreign_key: { to_table: :horses }
      t.integer :year, null: false, default: 0, index: true
      t.date :date, index: true
      t.date :due_date, index: true
      t.integer :fee, null: false, default: 0
      t.enum :status, enum_type: :breeding_statuses, null: false, index: true, comment: Config::Breedings.statuses.join(", ")
      t.integer :legacy_id, null: false, default: 0

      t.timestamps
    end

    add_index :breedings, %i[mare_id stud_id year], where: "status != 'denied'", unique: true
  end
end

