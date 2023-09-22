class PopulateTrainingScheduleHorseCount < ActiveRecord::Migration[7.0]
  def up
    Racing::TrainingScheduleHorse.counter_culture_fix_counts
  end

  def down
    Racing::TrainingScheduleHorse.counter_culture_fix_counts
  end
end

