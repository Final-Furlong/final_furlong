# frozen_string_literal: true

class MigrateToUuids < ActiveRecord::Migration[7.0]
  def up
    say_with_time "Migrating racetracks" do
      ActiveRecord::Base.connection.execute('
        INSERT INTO new_racetracks (name, state, country, latitude, longitude, created_at, updated_at)
        SELECT name, state, country, latitude, longitude, created_at, updated_at FROM racetracks')
      count1 = ActiveRecord::Base.connection.execute('SELECT COUNT(*) FROM new_racetracks')
      count2 = ActiveRecord::Base.connection.execute('SELECT COUNT(*) FROM racetracks')
      puts "Count: #{count1}" if count1 == count2
    end

    say_with_time "Migrating users" do
      ActiveRecord::Base.connection.execute('
        INSERT INTO new_users (username, status, name, admin, discourse_id, email, encrypted_password,
        reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at,
        last_sign_in_at, current_sign_in_ip, last_sign_in_ip, confirmation_token, confirmed_at,
        confirmation_sent_at, unconfirmed_email, failed_attempts, unlock_token, locked_at,
        discarded_at, created_at, updated_at)
        SELECT username, status, name, admin, discourse_id, email, encrypted_password,
        reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at,
        last_sign_in_at, current_sign_in_ip, last_sign_in_ip, confirmation_token, confirmed_at,
        confirmation_sent_at, unconfirmed_email, failed_attempts, unlock_token, locked_at,
        discarded_at, created_at, updated_at
        FROM users')
      count1 = ActiveRecord::Base.connection.execute('SELECT COUNT(*) FROM new_users')
      count2 = ActiveRecord::Base.connection.execute('SELECT COUNT(*) FROM users')
      puts "Count: #{count1}" if count1 == count2
    end

    say_with_time "Migrating stables" do
      ActiveRecord::Base.connection.execute('
        INSERT INTO new_stables (name, legacy_id, user_id, created_at, updated_at)
        SELECT s.name, s.id, u.id, s.created_at, s.updated_at FROM stables s
        LEFT JOIN users ou ON s.user_id = ou.id
        LEFT JOIN new_users u ON ou.username = u.username')
      count1 = ActiveRecord::Base.connection.execute('SELECT COUNT(*) FROM new_stables')
      count2 = ActiveRecord::Base.connection.execute('SELECT COUNT(*) FROM stables')
      puts "Count: #{count1}" if count1 == count2
    end

    say_with_time "Migrating horses" do
      ActiveRecord::Base.connection.execute('
        INSERT INTO new_horses (name, gender, status, date_of_birth, date_of_death, owner_id, breeder_id,
        location_bred_id, id, old_sire_id, old_dam_id)
        SELECT h.name, h.gender, h.status, h.date_of_birth, h.date_of_death, new_owner.id, new_breeder.id,
        new_racetrack.id, h.old_id, h.sire_id, h.dam_id
        FROM horses h LEFT JOIN
        stables owner ON h.owner_id = owner.id LEFT JOIN
        stables breeder ON h.breeder_id = breeder.id LEFT JOIN
        new_stables new_owner ON owner.name = new_owner.name LEFT JOIN
        new_stables new_breeder ON breeder.name = new_breeder.name LEFT JOIN
        racetracks r ON h.location_bred_id = r.id LEFT JOIN
        new_racetracks new_racetrack ON r.name = new_racetrack.name')
      ActiveRecord::Base.connection.execute('
        UPDATE new_horses nh LEFT JOIN new_horses sire ON nh.sire_id = sire.old_id
        SET sire_id = sire.id')
      ActiveRecord::Base.connection.execute('
        UPDATE new_horses nh LEFT JOIN new_horses dam ON nh.dam_id = dam.old_id
        SET dam_id = dam.id')
      count1 = ActiveRecord::Base.connection.execute('SELECT COUNT(*) FROM new_horses')
      count2 = ActiveRecord::Base.connection.execute('SELECT COUNT(*) FROM horses')
      puts "Count: #{count1}" if count1 == count2
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
