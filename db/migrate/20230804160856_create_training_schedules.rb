class CreateTrainingSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :training_schedules, id: :uuid do |t|
      t.references :stable, type: :uuid, null: false, index: true
      t.string :name, null: false
      t.text :description
      t.jsonb :sunday_activities, null: false, default: {}
      t.jsonb :monday_activities, null: false, default: {}
      t.jsonb :tuesday_activities, null: false, default: {}
      t.jsonb :wednesday_activities, null: false, default: {}
      t.jsonb :thursday_activities, null: false, default: {}
      t.jsonb :friday_activities, null: false, default: {}
      t.jsonb :saturday_activities, null: false, default: {}

      t.timestamps
    end

    add_index :training_schedules, :sunday_activities, using: :gin
    add_index :training_schedules, :monday_activities, using: :gin
    add_index :training_schedules, :tuesday_activities, using: :gin
    add_index :training_schedules, :wednesday_activities, using: :gin
    add_index :training_schedules, :thursday_activities, using: :gin
    add_index :training_schedules, :friday_activities, using: :gin
    add_index :training_schedules, :saturday_activities, using: :gin
  end
end

