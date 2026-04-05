class AddHorsesCountToRaceResult < ActiveRecord::Migration[8.1]
  def change
    add_column :race_results, :horses_count, :integer, default: 0, null: false
  end
end

