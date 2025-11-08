# frozen_string_literal: true

class MigrateCurrentLeases < ActiveRecord::Migration[8.1]
  def up
    Legacy::Lease.where(Active: true).find_each do |lease|
      MigrateLegacyLeasesService.new.call(lease.ID)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

