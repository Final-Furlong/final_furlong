class ValidateForeignKeys < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :race_result_horses, :odds, if_exists: true
    validate_foreign_key :training_schedules_horses, :training_schedules, column: :training_schedule_id
    validate_foreign_key :training_schedules, :stables, column: :stable_id
    validate_foreign_key :horses, :stables, column: :breeder_id
    validate_foreign_key :horses, :horses, column: :dam_id
  end
end

