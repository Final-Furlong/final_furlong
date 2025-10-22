class ReCreateRaces < ActiveRecord::Migration[8.0]
  def change
    drop_table :race_schedules if table_exists? :race_schedules # rubocop:disable Rails/ReversibleMigration

    types_list = %w[
      maiden
      claiming
      starter_allowance
      nw1_allowance
      nw2_allowance
      nw3_allowance
      allowance
      stakes
    ]
    ages_list = %w[2 2+ 3 3+ 4 4+]
    grades_list = ["Ungraded", "Grade 3", "Grade 2", "Grade 1"]

    create_table :race_schedules, id: :uuid do |t|
      t.integer :day_number, default: 1, null: false, index: true
      t.date :date, null: false, index: true
      t.integer :number, default: 1, null: false, index: true
      t.enum :race_type, enum_type: "race_type", default: "maiden", null: false, index: true, comment: types_list.join(", ")
      t.enum :age, enum_type: "race_age", default: "2", null: false, index: true, comment: ages_list.join(", ")
      t.boolean :male_only, default: false, null: false, index: true
      t.boolean :female_only, default: false, null: false, index: true
      t.decimal :distance, precision: 3, scale: 1, default: 5.0, null: false, index: true
      t.enum :grade, enum_type: "race_grade", index: true, comment: grades_list.join(", ")
      t.references :surface, type: :uuid, null: false, foreign_key: { to_table: :track_surfaces }
      t.string :name, index: true
      t.integer :purse, default: 0, null: false, index: true
      t.integer :claiming_price
      t.boolean :qualification_required, default: false, null: false, index: true

      t.timestamps
    end
  end
end

