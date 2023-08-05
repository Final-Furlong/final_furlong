module Legacy
  class TrainingScheduleHorse < Record
    self.table_name = "ff_training_schedule_horses"
  end
end

# == Schema Information
#
# Table name: ff_training_schedule_horses
#
#  Horse    :integer          not null, primary key
#  Schedule :integer          not null
#

