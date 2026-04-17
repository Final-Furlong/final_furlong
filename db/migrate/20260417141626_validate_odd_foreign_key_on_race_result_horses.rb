class ValidateOddForeignKeyOnRaceResultHorses < ActiveRecord::Migration[8.1]
  def change
    validate_foreign_key :race_result_horses, :race_odds
  end
end

