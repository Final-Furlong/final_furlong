class AddRacehorseStats < ActiveRecord::Migration[8.1]
  def change
    create_table :racehorse_stats do |t|
      t.references :horse, type: :bigint, null: false, index: true, foreign_key: { to_table: :horses }
      t.date :last_raced_at, index: true
      t.date :last_rested_at, index: true
      t.date :last_shipped_at, index: true
      t.integer :energy, default: 0, null: false, index: true
      t.integer :fitness, default: 0, null: false, index: true
      t.decimal :natural_energy, precision: 4, scale: 1, default: 0.0, null: false, index: true
      t.string :energy_grade, default: "F", null: false, index: true
      t.string :fitness_grade, default: "F", null: false, index: true
      t.integer :energy_regain_rate, default: 0, null: false, index: true
      t.integer :natural_energy_loss_rate, default: 0, null: false, index: true
      t.decimal :natural_energy_regain_rate, precision: 3, scale: 2, default: 0.0, null: false, index: true
      t.references :racetrack, type: :bigint, null: false, index: true, foreign_key: { to_table: :racetracks }
      t.boolean :at_home, default: true, null: false, index: true
      t.boolean :in_transit, default: false, null: false, index: true
      t.integer :desired_equipment, default: 0, null: false, index: true
      t.date :mature_at, null: false
      t.date :hasbeen_at, null: false

      t.timestamps
    end
  end
end

