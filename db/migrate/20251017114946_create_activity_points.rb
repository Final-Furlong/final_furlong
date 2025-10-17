class CreateActivityPoints < ActiveRecord::Migration[8.0]
  def change
    types_list = %w[
      color_war
      auction
      selling
      buying
      breeding
      claiming
      entering
      redeem
    ]
    create_enum :activity_type, types_list

    create_table :game_activity_points, id: :uuid do |t|
      t.enum :activity_type, enum_type: "activity_type", null: false, index: true, comment: types_list.join(", ")
      t.integer :first_year_points, default: 0, null: false
      t.integer :second_year_points, default: 0, null: false
      t.integer :older_year_points, default: 0, null: false

      t.timestamps
    end

    create_table :activity_points, id: :uuid do |t|
      t.references :stable, type: :uuid, null: false, foreign_key: { to_table: :stables }
      t.enum :activity_type, enum_type: "activity_type", null: false, index: true, comment: types_list.join(", ")
      t.references :budget, type: :uuid, foreign_key: { to_table: :budgets }
      t.integer :amount, default: 0, null: false
      t.integer :balance, default: 0, null: false

      t.timestamps
    end
  end
end

