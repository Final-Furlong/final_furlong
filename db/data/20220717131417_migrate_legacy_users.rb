class MigrateLegacyUsers < ActiveRecord::Migration[7.0]
  def up
    # return unless Rails.env.production?

    say_with_time "Deleting existing records" do
      ActiveRecord::Base.connection.execute("UPDATE horses SET owner_id = NULL, breeder_id = NULL;")
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE stables CASCADE;")
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE users CASCADE;")
    end
    say_with_time "Migrating legacy users" do
      say "Legacy user count: #{Legacy::User.count}"
      say "Migrating active users"
      # rubocop:disable Rails/WhereEquals
      Legacy::User.where("Status = ?", "A").find_each do |legacy_user|
        MigrateLegacyUserService.new(legacy_user.id).call
      end
      Legacy::User.where("Status = ?", "CW").find_each do |legacy_user|
        MigrateLegacyUserService.new(legacy_user.id).call
      end
      say "Migrating inactive users"
      Legacy::User.where("Status != ? AND Status != ?", "A", "CW").find_each do |legacy_user|
        MigrateLegacyUserService.new(legacy_user.id).call
      end
      # rubocop:enable Rails/WhereEquals
      say "Stable count: #{Account::Stable.count}"
      say "User count: #{Account::User.count}"
      say "Admin count: #{Account::User.where(admin: true).count}"
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

