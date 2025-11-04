module Legacy
  class TrainingScheduleDetail < Record
    self.table_name = "ff_training_schedule_details"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_training_schedule_details
# Database name: legacy
#
#  Activity1 :integer          not null
#  Activity2 :integer
#  Activity3 :integer
#  Day       :string(1)        not null, indexed, indexed => [Schedule]
#  Distance1 :integer          not null
#  Distance2 :integer
#  Distance3 :integer
#  ID        :integer          not null, primary key
#  Schedule  :integer          not null, indexed => [Day]
#
# Indexes
#
#  Day       (Day)
#  Schedule  (Schedule,Day)
#

