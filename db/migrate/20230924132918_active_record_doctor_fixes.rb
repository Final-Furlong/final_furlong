class ActiveRecordDoctorFixes < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :motor_forms, %i[author_type author_id], algorithm: :concurrently
    add_index :motor_dashboards, %i[author_type author_id], algorithm: :concurrently
    add_index :motor_queries, %i[author_type author_id], algorithm: :concurrently
    add_index :motor_alerts, %i[author_type author_id], algorithm: :concurrently

    change_column_null :training_schedules_horses, :training_schedule_id, false
    change_column_null :training_schedules_horses, :horse_id, false

    change_column_null :track_surfaces, :racetrack_id, false

    change_column_null :racetracks, :location_id, false

    change_column_null :horses, :location_bred_id, false

    change_column_null :settings, :user_id, false

    remove_index :users, :confirmation_token
    add_index :users, :confirmation_token, unique: true, where: "discarded_at IS NULL", algorithm: :concurrently
    remove_index :users, :created_at
    add_index :users, :created_at, where: "discarded_at IS NULL", algorithm: :concurrently
    remove_index :users, :discarded_at
    add_index :users, :discarded_at, where: "discarded_at IS NULL", algorithm: :concurrently
    remove_index :users, :discourse_id
    add_index :users, :discourse_id, unique: true, where: "discarded_at IS NULL", algorithm: :concurrently
    remove_index :users, :email
    add_index :users, :email, unique: true, where: "discarded_at IS NULL", algorithm: :concurrently
    remove_index :users, :reset_password_token
    add_index :users, :reset_password_token, unique: true, where: "discarded_at IS NULL", algorithm: :concurrently
    remove_index :users, :slug
    add_index :users, :slug, unique: true, where: "discarded_at IS NULL", algorithm: :concurrently
    remove_index :users, :unlock_token
    add_index :users, :unlock_token, unique: true, where: "discarded_at IS NULL", algorithm: :concurrently
    remove_index :users, :username
    add_index :users, :username, unique: true, where: "discarded_at IS NULL", algorithm: :concurrently

    remove_index :motor_alerts, %i[author_type author_id]
    add_index :motor_alerts, %i[author_type author_id], where: "deleted_at IS NULL", algorithm: :concurrently
    remove_index :motor_alerts, :query_id
    add_index :motor_alerts, :query_id, where: "deleted_at IS NULL", algorithm: :concurrently
    remove_index :motor_alerts, :updated_at
    add_index :motor_alerts, :updated_at, where: "deleted_at IS NULL", algorithm: :concurrently
    remove_index :motor_dashboards, %i[author_type author_id]
    add_index :motor_dashboards, %i[author_type author_id], where: "deleted_at IS NULL", algorithm: :concurrently
    remove_index :motor_dashboards, :updated_at
    add_index :motor_dashboards, :updated_at, where: "deleted_at IS NULL", algorithm: :concurrently
    add_index :motor_forms, :api_config_name, where: "deleted_at IS NULL", algorithm: :concurrently
    remove_index :motor_forms, %i[author_type author_id]
    add_index :motor_forms, %i[author_type author_id], where: "deleted_at IS NULL", algorithm: :concurrently
    remove_index :motor_forms, :updated_at
    add_index :motor_forms, :updated_at, where: "deleted_at IS NULL", algorithm: :concurrently
    remove_index :motor_queries, %i[author_type author_id]
    add_index :motor_queries, %i[author_type author_id], where: "deleted_at IS NULL", algorithm: :concurrently
    remove_index :motor_queries, :updated_at
    add_index :motor_queries, :updated_at, where: "deleted_at IS NULL", algorithm: :concurrently

    remove_index :motor_alert_locks, :alert_id

    safety_assured do
      reversible do |migration|
        migration.up do
          change_column :horses, :name, :string, limit: 18
        end
        migration.down do
          change_column :horses, :name, :string
        end
      end
    end

    ActiveRecord::Base.connection.execute <<-SQL.squish
      CREATE UNIQUE INDEX index_training_schedules_on_lowercase_name ON training_schedules (stable_id, lower(name));
    SQL

    remove_index :racetracks, :name
    ActiveRecord::Base.connection.execute <<-SQL.squish
      CREATE UNIQUE INDEX index_racetracks_on_lowercase_name ON racetracks (lower(name));
    SQL

    remove_index :users, :username
    ActiveRecord::Base.connection.execute <<-SQL.squish
      CREATE UNIQUE INDEX index_users_on_lowercase_username ON users (lower(username)) WHERE discarded_at IS NULL;
    SQL

    add_foreign_key :training_schedules, :stables
  end
end

