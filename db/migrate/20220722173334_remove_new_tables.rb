class RemoveNewTables < ActiveRecord::Migration[7.0] # rubocop:disable Metrics/ClassLength
  def up # rubocop:disable Metrics/CyclomaticComplexity
    drop_table :new_racetracks
    drop_table :new_users
    drop_table :new_stables
    drop_table :new_activations
    drop_table :new_horses

    add_column :racetracks, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }
    add_column :racetracks, :new_name, :string
    add_index :racetracks, :new_name, unique: true
    add_column :racetracks, :new_state, :string
    add_column :racetracks, :new_country, :string
    add_index :racetracks, :new_country
    add_column :racetracks, :new_latitude, :decimal
    add_index :racetracks, :new_latitude
    add_column :racetracks, :new_longitude, :decimal
    add_index :racetracks, :new_longitude
    add_column :racetracks, :new_created_at, :datetime
    add_column :racetracks, :new_updated_at, :datetime

    add_column :users, :uuid, :uuid, null: false, default: -> { "gen_random_uuid()" }
    add_column :users, :new_username, :string
    add_index :users, :new_username, unique: true
    add_column :users, :new_status, :enum, enum_type: "user_status", default: "pending",
                                           comment: "pending, active, deleted, banned"
    add_column :users, :new_name, :string
    add_column :users, :new_admin, :boolean, default: false
    add_column :users, :new_discourse_id, :integer, comment: "integer from Discourse forum"
    add_index :users, :new_discourse_id, unique: true
    add_column :users, :new_email, :string
    add_index :users, :new_email, unique: true
    add_column :users, :new_encrypted_password, :string, default: ""
    add_column :users, :new_reset_password_token, :string
    add_index :users, :new_reset_password_token, unique: true
    add_column :users, :new_reset_password_sent_at, :datetime, precision: nil
    add_column :users, :new_remember_created_at, :datetime, precision: nil
    add_column :users, :new_sign_in_count, :integer, default: 0
    add_column :users, :new_current_sign_in_at, :datetime, precision: nil
    add_column :users, :new_last_sign_in_at, :datetime, precision: nil
    add_column :users, :new_current_sign_in_ip, :string
    add_column :users, :new_last_sign_in_ip, :string
    add_column :users, :new_confirmation_token, :string
    add_index :users, :new_confirmation_token, unique: true
    add_column :users, :new_confirmed_at, :datetime, precision: nil
    add_column :users, :new_confirmation_sent_at, :datetime, precision: nil
    add_column :users, :new_unconfirmed_email, :string
    add_column :users, :new_failed_attempts, :integer, default: 0
    add_column :users, :new_unlock_token, :string
    add_index :users, :new_unlock_token, unique: true
    add_column :users, :new_locked_at, :datetime, precision: nil
    add_column :users, :new_created_at, :datetime
    add_column :users, :new_updated_at, :datetime
    add_column :users, :new_discarded_at, :datetime
    add_index :users, :new_discarded_at

    add_column :stables, :uuid, :uuid, default: -> { "gen_random_uuid()" }
    add_column :stables, :new_name, :string
    add_column :stables, :new_user_id, :uuid
    add_index :stables, :new_user_id
    add_column :stables, :legacy_id, :integer
    add_column :stables, :new_description, :text
    add_column :stables, :new_created_at, :datetime
    add_column :stables, :new_updated_at, :datetime

    add_column :activations, :new_user_id, :uuid

    add_column :horses, :uuid, :uuid, default: -> { "gen_random_uuid()" }
    add_column :horses, :new_name, :string
    add_index :horses, :new_name
    add_column :horses, :new_gender, :enum, enum_type: "horse_gender",
                                            comment: "colt, filly, stallion, mare, gelding"
    add_column :horses, :new_status, :enum, enum_type: "horse_status", default: "unborn",
                                            comment: "unborn, weanling, yearling, racehorse, broodmare, stud, retired, retired_broodmare, retired_stud, deceased"
    add_column :horses, :new_date_of_birth, :date
    add_index :horses, :new_date_of_birth
    add_column :horses, :new_date_of_death, :date
    add_column :horses, :age, :integer
    add_column :horses, :new_owner_id, :uuid
    add_column :horses, :new_breeder_id, :uuid
    add_column :horses, :new_location_bred_id, :uuid
    add_column :horses, :new_sire_id, :uuid
    add_column :horses, :new_dam_id, :uuid
    add_column :horses, :new_created_at, :datetime
    add_column :horses, :new_updated_at, :datetime

    # Populate UUID columns for associations
    execute <<-SQL.squish
      UPDATE racetracks SET new_name = name, new_state = state, new_country = country,
        new_latitude = latitude, new_longitude = longitude, new_created_at = created_at,
        new_updated_at = updated_at;

      UPDATE users SET new_username = username, new_status = status, new_name = name,
        new_admin = admin, new_discourse_id = discourse_id, new_email = email,
        new_encrypted_password = encrypted_password, new_reset_password_token = reset_password_token,
        new_reset_password_sent_at = reset_password_sent_at, new_remember_created_at = remember_created_at,
        new_sign_in_count = sign_in_count, new_current_sign_in_at = current_sign_in_at,
        new_last_sign_in_at = last_sign_in_at, new_current_sign_in_ip = current_sign_in_ip,
        new_last_sign_in_ip = last_sign_in_ip, new_confirmation_token = confirmation_token,
        new_confirmed_at = confirmed_at, new_confirmation_sent_at = confirmation_sent_at,
        new_unconfirmed_email = unconfirmed_email, new_failed_attempts = failed_attempts,
        new_unlock_token = unlock_token, new_locked_at = locked_at, new_discarded_at = discarded_at,
        new_created_at = created_at, new_updated_at = updated_at;

      UPDATE stables SET new_name = name, legacy_id = id, new_created_at = created_at, new_updated_at = updated_at;
      UPDATE stables SET new_user_id = users.uuid FROM users WHERE stables.user_id = users.id;

      UPDATE activations SET new_user_id = users.uuid FROM users WHERE activations.user_id = users.id;

      TRUNCATE horses;
    SQL

    # change column nulls
    change_column_null :racetracks, :new_name, false
    change_column_null :racetracks, :new_state, false
    change_column_null :racetracks, :new_country, false
    change_column_null :racetracks, :new_latitude, false
    change_column_null :racetracks, :new_longitude, false
    change_column_null :racetracks, :new_created_at, false
    change_column_null :racetracks, :new_updated_at, false

    change_column_null :users, :new_username, false
    change_column_null :users, :new_status, false
    change_column_null :users, :new_name, false
    change_column_null :users, :new_admin, false
    change_column_null :users, :new_email, false
    change_column_null :users, :new_encrypted_password, false
    change_column_null :users, :new_sign_in_count, false
    change_column_null :users, :new_failed_attempts, false

    change_column_null :stables, :new_name, false
    change_column_null :stables, :new_user_id, false
    change_column_null :stables, :legacy_id, false
    change_column_null :stables, :new_created_at, false
    change_column_null :stables, :new_updated_at, false

    change_column_null :activations, :new_user_id, false

    change_column_null :horses, :new_gender, false
    change_column_null :horses, :new_status, false
    change_column_null :horses, :new_date_of_birth, false
    change_column_null :horses, :new_owner_id, false
    change_column_null :horses, :new_breeder_id, false
    change_column_null :horses, :new_location_bred_id, false
    change_column_null :horses, :new_created_at, false
    change_column_null :horses, :new_updated_at, false

    # Migrate UUID to ID for associations
    remove_column :racetracks, :name
    remove_column :racetracks, :state
    remove_column :racetracks, :country
    remove_column :racetracks, :latitude
    remove_column :racetracks, :longitude
    remove_column :racetracks, :created_at
    remove_column :racetracks, :updated_at
    rename_column :racetracks, :new_name, :name
    rename_column :racetracks, :new_state, :state
    rename_column :racetracks, :new_country, :country
    rename_column :racetracks, :new_latitude, :latitude
    rename_column :racetracks, :new_longitude, :longitude
    rename_column :racetracks, :new_created_at, :created_at
    rename_column :racetracks, :new_updated_at, :updated_at

    remove_column :users, :username
    remove_column :users, :name
    remove_column :users, :status
    remove_column :users, :admin
    remove_column :users, :discourse_id
    remove_column :users, :email
    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
    remove_column :users, :sign_in_count
    remove_column :users, :current_sign_in_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip
    remove_column :users, :confirmation_token
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at
    remove_column :users, :unconfirmed_email
    remove_column :users, :failed_attempts
    remove_column :users, :unlock_token
    remove_column :users, :locked_at
    remove_column :users, :discarded_at
    remove_column :users, :created_at
    remove_column :users, :updated_at
    rename_column :users, :new_name, :name
    rename_column :users, :new_status, :status
    rename_column :users, :new_admin, :admin
    rename_column :users, :new_discourse_id, :discourse_id
    rename_column :users, :new_email, :email
    rename_column :users, :new_encrypted_password, :encrypted_password
    rename_column :users, :new_reset_password_token, :reset_password_token
    rename_column :users, :new_reset_password_sent_at, :reset_password_sent_at
    rename_column :users, :new_remember_created_at, :remember_created_at
    rename_column :users, :new_sign_in_count, :sign_in_count
    rename_column :users, :new_current_sign_in_at, :current_sign_in_at
    rename_column :users, :new_last_sign_in_at, :last_sign_in_at
    rename_column :users, :new_current_sign_in_ip, :current_sign_in_ip
    rename_column :users, :new_last_sign_in_ip, :last_sign_in_ip
    rename_column :users, :new_confirmation_token, :confirmation_token
    rename_column :users, :new_confirmed_at, :confirmed_at
    rename_column :users, :new_confirmation_sent_at, :confirmation_sent_at
    rename_column :users, :new_unconfirmed_email, :unconfirmed_email
    rename_column :users, :new_failed_attempts, :failed_attempts
    rename_column :users, :new_unlock_token, :unlock_token
    rename_column :users, :new_locked_at, :locked_at
    rename_column :users, :new_discarded_at, :discarded_at
    rename_column :users, :new_created_at, :created_at
    rename_column :users, :new_updated_at, :updated_at

    remove_column :stables, :name
    remove_column :stables, :user_id
    remove_column :stables, :created_at
    remove_column :stables, :updated_at
    rename_column :stables, :new_name, :name
    rename_column :stables, :new_user_id, :user_id
    rename_column :stables, :new_description, :description
    rename_column :stables, :new_created_at, :created_at
    rename_column :stables, :new_updated_at, :updated_at

    remove_column :activations, :user_id
    rename_column :activations, :new_user_id, :user_id

    remove_column :horses, :name
    remove_column :horses, :gender
    remove_column :horses, :status
    remove_column :horses, :date_of_birth
    remove_column :horses, :date_of_death
    remove_column :horses, :owner_id
    remove_column :horses, :breeder_id
    remove_column :horses, :location_bred_id
    remove_column :horses, :sire_id
    remove_column :horses, :dam_id
    remove_column :horses, :created_at
    remove_column :horses, :updated_at
    rename_column :horses, :new_name, :name
    rename_column :horses, :new_gender, :gender
    rename_column :horses, :new_status, :status
    rename_column :horses, :new_date_of_birth, :date_of_birth
    rename_column :horses, :new_date_of_death, :date_of_death
    rename_column :horses, :new_owner_id, :owner_id
    rename_column :horses, :new_breeder_id, :breeder_id
    rename_column :horses, :new_location_bred_id, :location_bred_id
    rename_column :horses, :new_sire_id, :sire_id
    rename_column :horses, :new_dam_id, :dam_id
    rename_column :horses, :new_created_at, :created_at
    rename_column :horses, :new_updated_at, :updated_at

    # Add indexes for associations
    add_index :stables, :user_id unless index_exists?(:stables, :user_id)
    add_index :activations, :user_id unless index_exists?(:activations, :user_id)
    add_index :horses, :owner_id unless index_exists?(:horses, :owner_id)
    add_index :horses, :breeder_id unless index_exists?(:horses, :breeder_id)
    add_index :horses, :location_bred_id unless index_exists?(:horses, :location_bred_id)
    add_index :horses, :sire_id unless index_exists?(:horses, :sire_id)
    add_index :horses, :dam_id unless index_exists?(:horses, :dam_id)

    # Migrate primary keys from UUIDs to IDs
    remove_column :racetracks, :id
    remove_column :stables, :id
    remove_column :users, :id
    remove_column :horses, :id

    rename_column :racetracks, :uuid, :id
    rename_column :stables,    :uuid, :id
    rename_column :users, :uuid, :id
    rename_column :horses, :uuid, :id
    execute "ALTER TABLE racetracks ADD PRIMARY KEY (id);"
    execute "ALTER TABLE stables ADD PRIMARY KEY (id);"
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"
    execute "ALTER TABLE horses ADD PRIMARY KEY (id);"

    # Add foreign keys
    add_foreign_key :stables, :users
    add_foreign_key :activations, :users
    add_foreign_key :horses, :stables, column: :owner_id
    add_foreign_key :horses, :stables, column: :breeder_id
    add_foreign_key :horses, :racetracks, column: :location_bred_id
    add_foreign_key :horses, :horses, column: :sire_id
    add_foreign_key :horses, :horses, column: :dam_id

    # Add indexes for ordering by date
    add_index :racetracks, :created_at
    add_index :stables, :created_at
    add_index :users, :created_at
    add_index :horses, :created_at
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
