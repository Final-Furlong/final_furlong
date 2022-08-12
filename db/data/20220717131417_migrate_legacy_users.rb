class MigrateLegacyUsers < ActiveRecord::Migration[7.0]
  def up
    # return unless Rails.env.production?

    say_with_time "Deleting existing records" do
      ActiveRecord::Base.connection.execute("UPDATE horses SET owner_id = NULL, breeder_id = NULL;")
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE stables CASCADE;")
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE users CASCADE;")
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
      say "Stable count: #{Stable.count}"
      say "User count: #{User.count}"
      say "Admin count: #{User.where(admin: true).count}"
    end
  end

  def down
    # return unless Rails.env.production?

    say_with_time "Deleting existing users" do
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE stables CASCADE;")
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE users CASCADE;")
    end
  end
end

