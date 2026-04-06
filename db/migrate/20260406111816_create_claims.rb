class CreateClaims < ActiveRecord::Migration[8.1]
  def change
    create_table :claims do |t|
      t.references :entry, type: :bigint, null: false, index: true, foreign_key: { to_table: :race_entries }
      t.references :claimer, type: :bigint, null: false, index: false, foreign_key: { to_table: :stables }
      t.references :owner, type: :bigint, null: false, index: true, foreign_key: { to_table: :stables }
      t.date :race_date, null: false, index: true
      t.timestamps
    end
    add_index :claims, %i[claimer_id race_date], unique: true
  end
end

