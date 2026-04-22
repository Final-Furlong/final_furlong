class CreateWeatherForecasts < ActiveRecord::Migration[8.1]
  def change
    conditions = %w[fast good slow wet]

    create_table :weather_forecasts do |t|
      t.references :surface, type: :bigint, null: false, index: false, foreign_key: { to_table: :track_surfaces }
      t.date :date, index: true, null: false
      t.enum :condition, enum_type: :track_condition, comment: conditions.join(", ")
      t.integer :rain_chance, default: 0, null: false

      t.timestamps
    end

    add_index :weather_forecasts, %i[surface_id date], unique: true
  end
end

