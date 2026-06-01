class CreateRaceSeries < ActiveRecord::Migration[8.1]
  def change
    create_table :race_series do |t|
      t.string :title, null: false, index: true
      t.references :first_race, type: :bigint, null: false, index: false, foreign_key: { to_table: :race_schedules }
      t.references :second_race, type: :bigint, null: false, index: true, foreign_key: { to_table: :race_schedules }
      t.references :third_race, type: :bigint, null: false, index: true, foreign_key: { to_table: :race_schedules }
      t.enum :age, enum_type: :race_age, null: false, index: true
      t.boolean :female_only, default: false, null: false, index: true

      t.timestamps
    end

    add_index :race_series, %i[first_race_id second_race_id third_race_id]
  end
end

