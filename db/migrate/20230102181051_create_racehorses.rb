class CreateRacehorses < ActiveRecord::Migration[7.0]
  def change
    create_table :racehorses, id: :uuid do |t|
      t.integer :break, null: false
      t.integer :min_speed, null: false
      t.integer :ave_speed, null: false
      t.integer :max_speed, null: false
      t.integer :stamina, null: false
      t.integer :sustain, null: false
      t.integer :consistency, null: false
      t.integer :fast, null: false
      t.integer :good, null: false
      t.integer :wet, null: false
      t.integer :slow, null: false
      t.integer :dirt, null: false
      t.integer :turf, null: false
      t.integer :steeplechase, null: false
      t.integer :courage, null: false
      t.date :immature_date, null: false
      t.date :hasbeen_date, null: false
      t.integer :lead, null: false
      t.integer :pace, null: false
      t.integer :midpack, null: false
      t.integer :close, null: false
      t.integer :soundness, null: false
      t.integer :fitness, null: false
      t.string :fitness_grade, length: 1, null: false
      t.integer :energy, null: false
      t.string :energy_grade, length: 1, null: false
      t.integer :energy_minimum, null: false
      t.integer :enery_regain, null: false
      t.decimal :morale, precision: 4, scale: 1, null: false
      t.integer :morale_loss, null: false
      t.integer :morale_gain, null: false
      t.integer :pissy, null: false
      t.integer :ratability, null: false
      t.integer :equipment, null: false
      t.integer :default_equipment, null: false
      t.decimal :strides_per_second, precision: 5, scale: 3, null: false
      t.integer :loaf_threshold, null: false
      t.integer :loaf_percent, null: false
      t.integer :acceleration, null: false
      t.integer :traffic, null: false
      t.integer :xp_rate, null: false
      t.integer :xp_current, null: false
      t.integer :turning, null: false
      t.integer :weight, null: false
      t.uuid :last_race_id
      t.integer :last_race_finishers
      t.integer :races_count, null: false, default: 0
      t.integer :rest_day_count, null: false, default: 0

      t.timestamps
    end
  end
end

