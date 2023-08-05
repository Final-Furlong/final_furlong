class CreateTrainingScheduleHorses < ActiveRecord::Migration[7.0]
  def change
    create_table :training_schedules_horses do |t|
      t.references :training_schedule, type: :uuid
      t.references :horse, type: :uuid

      t.timestamps
    end

    add_foreign_key :training_schedules_horses, :training_schedules, type: :uuid
    add_foreign_key :training_schedules_horses, :horses, type: :uuid
  end
end

