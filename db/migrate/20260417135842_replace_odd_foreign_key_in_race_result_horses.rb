class ReplaceOddForeignKeyInRaceResultHorses < ActiveRecord::Migration[8.1]
  def change
    # rubocop:disable Rails/ReversibleMigration
    remove_foreign_key :race_result_horses, column: :odd_id
    add_foreign_key :race_result_horses, :race_odds, column: :odd_id, validate: false
    # rubocop:enable Rails/ReversibleMigration
  end
end

