class UpdateJockeyAndOddsFieldsForRaceResultHorse < ActiveRecord::Migration[8.0]
  def change
    change_column_null :race_result_horses, :jockey_id, true
    change_column_null :race_result_horses, :odd_id, true
  end
end

