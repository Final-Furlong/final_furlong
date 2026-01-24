module Legacy
  class TrainingScheduleHorse < Record
    self.table_name = "ff_training_schedule_horses"

    belongs_to :horse, class_name: "Legacy::Horse", foreign_key: "Horse"
  end
end

# == Schema Information
#
# Table name: ff_training_schedule_horses
# Database name: legacy
#
#  Horse    :integer          not null, primary key
#  Schedule :integer          not null
#

