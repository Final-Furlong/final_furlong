class CreateWorkouts < ActiveRecord::Migration[8.1]
  def change
    workout_stats = %w[
      bolt
      confidence
      cooperate
      dump
      energy
      equipment
      fight
      fitness
      happy
      jumps
      natural_energy
      pissy
      ratability
      spook
      stamina
      style
      weight
      xp
    ]
    create_enum :workout_stats, workout_stats

    create_table :workout_comments do |t|
      t.string :comment_i18n_key
      t.enum :stat, enum_type: :workout_stats, null: false, index: true
      t.integer :stat_value, index: true
      t.string :placeholders

      t.timestamps
    end

    conditions = %w[fast good slow wet]
    activities = %w[walk jog canter gallop breeze]
    create_enum :workout_activities, activities
    create_table :workouts do |t|
      t.references :horse, type: :bigint, null: false, foreign_key: { to_table: :horses }
      t.references :jockey, type: :bigint, null: false, foreign_key: { to_table: :jockeys }
      t.date :date, null: false, index: true
      t.references :racetrack, type: :bigint, null: false, foreign_key: { to_table: :racetracks }
      t.references :surface, type: :bigint, null: false, foreign_key: { to_table: :track_surfaces }
      t.references :location, type: :bigint, null: false, foreign_key: { to_table: :locations }
      t.enum :condition, enum_type: :track_condition, null: false, index: true, comment: conditions.join(", ")
      t.integer :equipment, null: false, default: 0, index: true
      t.references :comment, type: :bigint, null: false, foreign_key: { to_table: :workout_comments }
      t.integer :effort, null: false, default: 0, index: true
      t.integer :confidence, null: false, default: 0, index: true
      t.integer :rank, index: true
      t.integer :time_in_seconds, index: true
      t.enum :activity1, enum_type: :workout_activities, null: false, index: true, comment: activities.join(", ")
      t.integer :distance1, null: false, default: 0, index: true
      t.enum :activity2, enum_type: :workout_activities, index: true, comment: activities.join(", ")
      t.integer :distance2, default: 0, index: true
      t.enum :activity3, enum_type: :workout_activities, index: true, comment: activities.join(", ")
      t.integer :distance3, default: 0, index: true

      t.timestamps
    end
  end
end

