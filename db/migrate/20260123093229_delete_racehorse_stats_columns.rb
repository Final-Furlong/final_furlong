class DeleteRacehorseStatsColumns < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      remove_column :racehorse_stats, :energy, :integer
      remove_column :racehorse_stats, :fitness, :integer
      remove_column :racehorse_stats, :desired_equipment, :integer
      remove_column :racehorse_stats, :energy_regain_rate, :integer
      remove_column :racehorse_stats, :hasbeen_at, :date
      remove_column :racehorse_stats, :mature_at, :date
      remove_column :racehorse_stats, :natural_energy, :decimal, precision: 4, scale: 1
      remove_column :racehorse_stats, :natural_energy_loss_rate, :integer
      remove_column :racehorse_stats, :natural_energy_regain_rate, :decimal, precision: 3, scale: 2
    end
  end
end

