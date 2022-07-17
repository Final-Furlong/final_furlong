class MigrateLegacyUsers < ActiveRecord::Migration[7.0]
  def up
    say_with_time "Deleting existing records" do
      Horse.update_all(owner_id: nil, breeder_id: nil) # rubocop:disable Rails/SkipsModelValidations
      Stable.destroy_all
      User.destroy_all
    end
    say_with_time "Migrating legacy users" do
      say "Legacy user count: #{LegacyUser.count}"
      LegacyUser.find_each do |legacy_user|
        MigrateLegacyUserService.new(legacy_user.id).call
      end
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

  def down
    say_with_time "Deleting existing users" do
      Stable.destroy_all
      User.destroy_all
    end
  end
end
