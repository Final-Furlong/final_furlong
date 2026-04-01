class AddEarningsAndPointsToRaceResultHorses < ActiveRecord::Migration[8.1]
  def change
    add_column :race_result_horses, :earnings, :integer, default: 0, null: false
    add_column :race_result_horses, :points, :integer, default: 0, null: false
  end
end

