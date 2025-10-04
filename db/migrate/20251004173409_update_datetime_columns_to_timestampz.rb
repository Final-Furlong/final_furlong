class UpdateDatetimeColumnsToTimestampz < ActiveRecord::Migration[8.0]
  def up
    ActiveRecord::Base.connection.execute <<-SQL.squish
      SET timezone = 'UTC';

      ALTER TABLE activations
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz,
        ALTER activated_at TYPE timestamptz;

      ALTER TABLE active_storage_attachments
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now();

      ALTER TABLE active_storage_blobs
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now();

      ALTER TABLE ar_internal_metadata
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE auction_bids
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE auction_horses
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz,
        ALTER sold_at TYPE timestamptz;

      ALTER TABLE auctions
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz,
        ALTER start_time TYPE timestamptz,
        ALTER end_time TYPE timestamptz;

      ALTER TABLE horse_appearances
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE horse_genetics
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE horses
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE locations
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE motor_alert_locks
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE motor_alerts
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz,
        ALTER deleted_at TYPE timestamptz;

      ALTER TABLE motor_api_configs
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz,
        ALTER deleted_at TYPE timestamptz;

      ALTER TABLE motor_audits
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE motor_configs
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE motor_dashboards
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz,
        ALTER deleted_at TYPE timestamptz;

      ALTER TABLE motor_forms
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz,
        ALTER deleted_at TYPE timestamptz;

      ALTER TABLE motor_queries
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz,
        ALTER deleted_at TYPE timestamptz;

      ALTER TABLE motor_resources
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE motor_taggable_tags
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE motor_tags
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE racetracks
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE sessions
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE settings
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE stables
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz,
        ALTER last_online_at TYPE timestamptz;

      ALTER TABLE track_surfaces
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE training_schedules
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE training_schedules_horses
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz;

      ALTER TABLE users
        ALTER created_at TYPE timestamptz,
        ALTER created_at SET DEFAULT now(),
        ALTER updated_at TYPE timestamptz,
        ALTER reset_password_sent_at TYPE timestamptz,
        ALTER remember_created_at TYPE timestamptz,
        ALTER current_sign_in_at TYPE timestamptz,
        ALTER last_sign_in_at TYPE timestamptz,
        ALTER confirmed_at TYPE timestamptz,
        ALTER confirmation_sent_at TYPE timestamptz,
        ALTER locked_at TYPE timestamptz,
        ALTER discarded_at TYPE timestamptz;
    SQL
  end

  def down
    ActiveRecord::Base.connection.execute <<-SQL.squish
      SET timezone = 'UTC';

      ALTER TABLE activations
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone,
        ALTER activated_at TYPE timestamp(6) without time zone;

      ALTER TABLE active_storage_attachments
        ALTER created_at TYPE timestamp(6) without time zone;

      ALTER TABLE active_storage_blobs
        ALTER created_at TYPE timestamp(6) without time zone;

      ALTER TABLE ar_internal_metadata
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE auction_bids
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE auction_horses
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone,
        ALTER sold_at TYPE timestamp(6) without time zone;

      ALTER TABLE auctions
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone,
        ALTER start_time TYPE timestamp(6) without time zone,
        ALTER end_time TYPE timestamp(6) without time zone;

      ALTER TABLE horse_appearances
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE horse_genetics
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE horses
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE locations
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE motor_alert_locks
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE motor_alerts
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone,
        ALTER deleted_at TYPE timestamp(6) without time zone;

      ALTER TABLE motor_api_configs
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone,
        ALTER deleted_at TYPE timestamp(6) without time zone;

      ALTER TABLE motor_audits
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE motor_configs
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE motor_dashboards
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone,
        ALTER deleted_at TYPE timestamp(6) without time zone;

      ALTER TABLE motor_forms
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone,
        ALTER deleted_at TYPE timestamp(6) without time zone;

      ALTER TABLE motor_queries
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone,
        ALTER deleted_at TYPE timestamp(6) without time zone;

      ALTER TABLE motor_resources
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE motor_taggable_tags
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE motor_tags
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE racetracks
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE sessions
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE settings
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE stables
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone,
        ALTER last_online_at TYPE timestamp(6) without time zone;

      ALTER TABLE track_surfaces
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE training_schedules
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE training_schedules_horses
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone;

      ALTER TABLE users
        ALTER created_at TYPE timestamp(6) without time zone,
        ALTER updated_at TYPE timestamp(6) without time zone,
        ALTER reset_password_sent_at TYPE timestamp(6) without time zone,
        ALTER remember_created_at TYPE timestamp(6) without time zone,
        ALTER current_sign_in_at TYPE timestamp(6) without time zone,
        ALTER last_sign_in_at TYPE timestamp(6) without time zone,
        ALTER confirmed_at TYPE timestamp(6) without time zone,
        ALTER confirmation_sent_at TYPE timestamp(6) without time zone,
        ALTER locked_at TYPE timestamp(6) without time zone,
        ALTER discarded_at TYPE timestamp(6) without time zone;
    SQL
  end
end

