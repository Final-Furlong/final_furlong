class DeleteMotorAdminTables < ActiveRecord::Migration[8.1]
  def change
    # rubocop:disable Rails/ReversibleMigration
    drop_table :motor_alert_locks, if_exists: true
    drop_table :motor_alerts, if_exists: true
    drop_table :motor_api_configs, if_exists: true
    drop_table :motor_audits, if_exists: true
    drop_table :motor_configs, if_exists: true
    drop_table :motor_dashboards, if_exists: true
    drop_table :motor_forms, if_exists: true
    drop_table :motor_queries, if_exists: true
    drop_table :motor_resources, if_exists: true
    drop_table :motor_taggable_tags, if_exists: true
    drop_table :motor_tags, if_exists: true
    # rubocop:enable Rails/ReversibleMigration
  end
end

