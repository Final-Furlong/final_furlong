class CreateRacingStats < ActiveRecord::Migration[8.1]
  def change
    create_table :racing_stats do |t|
      t.references :horse, type: :bigint, null: false, foreign_key: { to_table: :horses }
      t.integer :acceleration, null: false, default: 0
      t.integer :average_speed, null: false, default: 0
      t.integer :break_speed, null: false, default: 0
      t.integer :closing, null: false, default: 0
      t.integer :consistency, null: false, default: 0
      t.integer :courage, null: false, default: 0
      t.integer :desired_equipment, null: false, default: 0
      t.integer :dirt, null: false, default: 0
      t.integer :energy, null: false, default: 0
      t.integer :energy_minimum, null: false, default: 0
      t.integer :energy_regain, null: false, default: 0
      t.integer :fitness, null: false, default: 0
      t.integer :leading, null: false, default: 0
      t.integer :loaf_percent, null: false, default: 0
      t.integer :loaf_threshold, null: false, default: 0
      t.integer :max_speed, null: false, default: 0
      t.integer :midpack, null: false, default: 0
      t.integer :min_speed, null: false, default: 0
      t.decimal :natural_energy_current, null: false, default: 0.0, precision: 5, scale: 3
      t.decimal :natural_energy_gain, null: false, default: 0.0, precision: 5, scale: 3
      t.integer :natural_energy_loss, null: false, default: 0
      t.integer :off_pace, null: false, default: 0
      t.date :peak_end_date, null: false, default: "NOW()"
      t.date :peak_start_date, null: false, default: "NOW()"
      t.integer :pissy, null: false, default: 0
      t.integer :ratability, null: false, default: 0
      t.integer :soundness, null: false, default: 0
      t.integer :stamina, null: false, default: 0
      t.integer :steeplechase, null: false, default: 0
      t.decimal :strides_per_second, null: false, default: 0.0, precision: 5, scale: 3
      t.integer :sustain, null: false, default: 0
      t.integer :track_fast, null: false, default: 0
      t.integer :track_good, null: false, default: 0
      t.integer :track_slow, null: false, default: 0
      t.integer :track_wet, null: false, default: 0
      t.integer :traffic, null: false, default: 0
      t.integer :turf, null: false, default: 0
      t.integer :turning, null: false, default: 0
      t.integer :weight, null: false, default: 0
      t.integer :xp_current, null: false, default: 0
      t.integer :xp_rate, null: false, default: 0

      t.timestamps
    end
  end
end

