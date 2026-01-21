class UpdateNatEnergyInRacingStats < ActiveRecord::Migration[8.1]
  def change
    # rubocop:disable Rails/ReversibleMigration
    safety_assured do
      change_column :racing_stats, :natural_energy_current, :float, precision:
        6, scale: 3
    end
    # rubocop:enable Rails/ReversibleMigration
  end
end

