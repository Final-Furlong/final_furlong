class RecreateTrainingSchedulesTable < ActiveRecord::Migration[8.1]
  def change
    # rubocop:disable Rails/ReversibleMigration
    drop_table :training_schedules, force: :cascade, if_exists: true
    # rubocop:enable Rails/ReversibleMigration

    create_table :training_schedules do |t|
      t.references :stable, type: :bigint, null: false, index: true
      t.string :name, null: false
      t.integer :horses_count, default: 0, null: false
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

    ActiveRecord::Base.connection.execute <<-SQL.squish
      CREATE UNIQUE INDEX index_training_schedules_on_lowercase_name ON training_schedules (stable_id, lower(name));
    SQL
  end
end

