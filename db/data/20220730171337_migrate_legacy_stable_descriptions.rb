class MigrateLegacyStableDescriptions < ActiveRecord::Migration[7.0]
  def up
    return unless Rails.env.test? || Rails.env.production?

    say_with_time "Migrating legacy descriptions" do
      LegacyUser.where.not(Status: "D").find_each do |legacy_user|
        stable = Stable.find_by(legacy_id: legacy_user.id)
        stable.description = legacy_user.description
        stable.save!
      end
    end
  end

  def down
    Stable.update_all(description: nil) # rubocop:disable Rails/SkipsModelValidations
  end
end

