class MigrateLegacyTrainingSchedules < ActiveRecord::Migration[7.0]
  def up
    say_with_time "Migrating legacy training schedules" do
      say "Legacy schedule count: #{Legacy::TrainingSchedule.count}"
      Legacy::TrainingSchedule.find_each do |legacy_schedule|
        MigrateLegacyTrainingScheduleService.new(legacy_schedule:).call
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

