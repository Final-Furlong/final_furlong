class CreateWorkoutStats < ActiveRecord::Migration[8.1]
  def change
    activities = %w[walk jog canter gallop breeze]

    rename_enum :workout_stats, :workout_stat_types

    create_table :workout_stats do |t|
      t.references :horse, type: :bigint, null: false, index: false, foreign_key: { to_table: :horses }
      t.enum :activity, enum_type: :workout_activity_types, null: false, index: true, comment: activities.join(", ")
      t.decimal :best_time_in_seconds, null: false, default: 0, precision: 6, scale: 3, index: true
      t.date :best_date, null: false, index: true
      t.decimal :recent_time_in_seconds, null: false, default: 0, precision: 6, scale: 3, index: true
      t.date :recent_date, null: false, index: true

      t.timestamps
    end
    add_index :workout_stats, %i[horse_id activity], unique: true
  end
end

