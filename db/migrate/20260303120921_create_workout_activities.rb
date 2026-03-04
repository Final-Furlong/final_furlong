class CreateWorkoutActivities < ActiveRecord::Migration[8.1]
  def change
    activities = %w[walk jog canter gallop breeze]

    rename_enum :workout_activities, :workout_activity_types

    create_table :workout_activities do |t|
      t.references :workout, type: :bigint, null: false, index: false, foreign_key: { to_table: :workouts }
      t.enum :activity, enum_type: :workout_activity_types, null: false, index: true, comment: activities.join(", ")
      t.integer :distance, null: false, default: 0, index: true
      t.integer :activity_index, null: false, default: 1, index: true
      t.integer :time_in_seconds, index: true

      t.timestamps
    end

    add_index :workout_activities, %i[workout_id activity], unique: true
    add_index :workout_activities, %i[workout_id activity_index], unique: true

    safety_assured { remove_column :workouts, :rank }
  end
end

