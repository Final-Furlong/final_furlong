# frozen_string_literal: true

class AddColourForHorse < ActiveRecord::Migration[8.1]
  def up
    horse = Horses::Horse.find(12160)
    appearance = horse.appearance || horse.build_appearance
    appearance.update(
      color: "bay",
      max_height: 16.1,
      birth_height: 10.0,
      current_height: 16.1
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

