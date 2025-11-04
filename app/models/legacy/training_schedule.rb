module Legacy
  class TrainingSchedule < Record
    self.table_name = "ff_training_schedules"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_training_schedules
# Database name: legacy
#
#  Description :string(255)
#  Horse       :integer          indexed
#  ID          :integer          not null, primary key
#  Name        :string(255)
#  Stable      :integer          indexed
#
# Indexes
#
#  horse   (Horse)
#  stable  (Stable)
#

