module Legacy
  class WorkoutBonus < Record
    self.table_name = "ff_workout_bonuses"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_workout_bonuses
#
#  Bonus :integer          not null
#  Horse :integer          default(0), not null
#  ID    :integer          not null, primary key
#  Stat  :string(255)      not null
#

