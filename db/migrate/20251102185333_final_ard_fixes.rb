class FinalArdFixes < ActiveRecord::Migration[8.1]
  def change
    remove_index :users, column: :old_id, if_exists: true
    safety_assured do
      remove_column :users, :old_id, if_exists: true
    end

    add_foreign_key :training_schedules, :stables, on_delete: :cascade, on_update: :cascade, validate: false, if_not_exists: true
    add_foreign_key :training_schedules_horses, :horses, on_delete: :cascade, on_update: :cascade, validate: false, if_not_exists: true
    add_foreign_key :training_schedules_horses, :training_schedules, on_delete: :cascade, on_update: :cascade, validate: false, if_not_exists: true
  end
end

