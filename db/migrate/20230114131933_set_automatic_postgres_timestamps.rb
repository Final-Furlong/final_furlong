class SetAutomaticPostgresTimestamps < ActiveRecord::Migration[7.0]
  def change
    ActiveRecord::Base.connection.execute <<-SQL.squish
      CREATE OR REPLACE FUNCTION trigger_set_timestamp()
      RETURNS TRIGGER AS $$
      BEGIN
        NEW.updated_at = NOW();
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;

      ALTER TABLE activations ALTER created_at SET DEFAULT NOW();
      ALTER TABLE activations ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON activations
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE horses ALTER created_at SET DEFAULT NOW();
      ALTER TABLE horses ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON horses
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE locations ALTER created_at SET DEFAULT NOW();
      ALTER TABLE locations ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON locations
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE motor_alert_locks ALTER created_at SET DEFAULT NOW();
      ALTER TABLE motor_alert_locks ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON motor_alert_locks
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE motor_alerts ALTER created_at SET DEFAULT NOW();
      ALTER TABLE motor_alerts ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON motor_alerts
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE motor_api_configs ALTER created_at SET DEFAULT NOW();
      ALTER TABLE motor_api_configs ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON motor_api_configs
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE motor_audits ALTER created_at SET DEFAULT NOW();
      ALTER TABLE motor_audits ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON motor_audits
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE motor_configs ALTER created_at SET DEFAULT NOW();
      ALTER TABLE motor_configs ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON motor_configs
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE motor_dashboards ALTER created_at SET DEFAULT NOW();
      ALTER TABLE motor_dashboards ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON motor_dashboards
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE motor_forms ALTER created_at SET DEFAULT NOW();
      ALTER TABLE motor_forms ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON motor_forms
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE motor_queries ALTER created_at SET DEFAULT NOW();
      ALTER TABLE motor_queries ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON motor_queries
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE motor_resources ALTER created_at SET DEFAULT NOW();
      ALTER TABLE motor_resources ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON motor_resources
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE motor_taggable_tags ALTER created_at SET DEFAULT NOW();
      ALTER TABLE motor_taggable_tags ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON motor_taggable_tags
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE motor_tags ALTER created_at SET DEFAULT NOW();
      ALTER TABLE motor_tags ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON motor_tags
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE racetracks ALTER created_at SET DEFAULT NOW();
      ALTER TABLE racetracks ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON racetracks
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE sessions ALTER created_at SET DEFAULT NOW();
      ALTER TABLE sessions ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON sessions
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE stables ALTER created_at SET DEFAULT NOW();
      ALTER TABLE stables ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON stables
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE track_surfaces ALTER created_at SET DEFAULT NOW();
      ALTER TABLE track_surfaces ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON track_surfaces
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();

      ALTER TABLE users ALTER created_at SET DEFAULT NOW();
      ALTER TABLE users ALTER updated_at SET DEFAULT NOW();
      CREATE TRIGGER set_timestamp
      BEFORE UPDATE ON users
        FOR EACH ROW
      EXECUTE PROCEDURE trigger_set_timestamp();
    SQL
  end
end

