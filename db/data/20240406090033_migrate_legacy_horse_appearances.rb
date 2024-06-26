class MigrateLegacyHorseAppearances < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    say_with_time "Migrating legacy horse appearances" do
      say "Legacy horse count: #{Legacy::Horse.count}"
      max_id = Horses::Horse.where.associated(:appearance).maximum("legacy_id")
      legacy_horses = Legacy::Horse
      legacy_horses = legacy_horses.where(id: max_id..) if max_id
      legacy_horses.find_each do |legacy_horse|
        MigrateLegacyHorseAppearanceService.new(legacy_horse:).call
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

