module Legacy
  class Workout < Record
    self.table_name = "ff_workouts"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_workouts
#
#  Activity1  :integer          not null
#  Activity2  :integer
#  Activity3  :integer
#  Comment    :integer          not null
#  Condition  :integer          not null
#  DTSC       :integer          not null
#  Date       :date             not null, indexed, indexed => [Location], indexed => [Horse]
#  Distance1  :integer          default(0), not null
#  Distance2  :integer
#  Distance3  :integer
#  Effort     :integer          default(0), not null
#  Equipment  :integer
#  Horse      :integer          default(0), not null, indexed, indexed => [Date]
#  ID         :integer          not null, primary key
#  Jockey     :integer          default(0), not null
#  Location   :integer          default(0), not null, indexed => [Date]
#  Rank       :integer
#  Time       :float(53)
#  confidence :integer          default(0)
#
# Indexes
#
#  date           (Date)
#  date_location  (Date,Location)
#  horse          (Horse)
#  horse_date     (Horse,Date)
#

