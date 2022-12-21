# frozen_string_literal: true

class MigrateLegacyHorseAppearance < ActiveRecord::Migration[7.0]
  def up; end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

