class CreateJumpTrials < ActiveRecord::Migration[8.1]
  def change
    create_table :jump_trials do |t|
      t.references :horse, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.references :jockey, type: :bigint, null: false, index: true, foreign_key: { to_table: :jockeys }
      t.date :date, null: false
      t.enum :condition, enum_type: :track_condition, null: false
      t.references :racetrack, type: :bigint, null: false, index: true, foreign_key: { to_table: :racetracks }
      t.integer :distance, default: 0, null: false
      t.references :comment, type: :bigint, null: false, index: true, foreign_key: { to_table: :workout_comments }
      t.integer :time_in_seconds, default: 0, null: false, index: true

      t.timestamps
    end

    add_index :jump_trials, %i[horse_id date], unique: true
  end
end

