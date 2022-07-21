class MigrateLegacyUsers < ActiveRecord::Migration[7.0]
  def up
    if Rails.env.production?
    say_with_time "Deleting existing records" do
      ActiveRecord::Base.connection.execute("UPDATE horses SET owner_id = NULL, breeder_id = NULL;")
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE stables CASCADE;")
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE users CASCADE;")
      ActiveRecord::Base.connection.execute("ALTER SEQUENCE public.stables_id_seq RESTART 1;")
      ActiveRecord::Base.connection.execute("ALTER SEQUENCE public.users_id_seq RESTART 1;")
    end
    say_with_time "Migrating legacy users" do
      say "Legacy user count: #{LegacyUser.count}"
      say "Migrating active users"
      # rubocop:disable Rails/WhereEquals
      LegacyUser.where("Status = ?", "A").find_each do |legacy_user|
        MigrateLegacyUserService.new(legacy_user.id).call
      end
      LegacyUser.where("Status = ?", "CW").find_each do |legacy_user|
        MigrateLegacyUserService.new(legacy_user.id).call
      end
      say "Migrating inactive users"
      LegacyUser.where("Status != ? AND Status != ?", "A", "CW").find_each do |legacy_user|
        MigrateLegacyUserService.new(legacy_user.id).call
      end
      # rubocop:enable Rails/WhereEquals
      last_legacy_user = LegacyUser.order(id: :desc).first
      sleep(0.1) while !User.exists?(email: last_legacy_user.email) || !Stable.exists?(id: last_legacy_user.id)
      say "Stable count: #{Stable.count}"
      say "User count: #{User.count}"
      say "Admin count: #{User.where(admin: true).count}"
    end
    say_with_time "Setting sequences" do
      last_stable = Stable.order(id: :desc).first
      ActiveRecord::Base.connection.execute("ALTER SEQUENCE public.stables_id_seq RESTART #{last_stable.id + 1};")
      last_user = User.order(id: :desc).first
      ActiveRecord::Base.connection.execute("ALTER SEQUENCE public.users_id_seq RESTART #{last_user.id + 1};")
    end
    end
  end

  def down
    if Rails.env.production?
    say_with_time "Deleting existing users" do
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE stables CASCADE;")
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE users CASCADE;")
      ActiveRecord::Base.connection.execute("ALTER SEQUENCE public.stables_id_seq RESTART 1;")
      ActiveRecord::Base.connection.execute("ALTER SEQUENCE public.users_id_seq RESTART 1;")
    end
    end
  end
end
