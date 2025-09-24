module Legacy
  class RaceResult < Record
    self.table_name = "ff_raceresults"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_raceresults
#
#  Age       :integer          default(0), not null, indexed
#  Condition :integer          default(0), not null, indexed
#  Date      :date             indexed, uniquely indexed => [Num], indexed => [Type]
#  Distance  :float(53)        indexed
#  Gender    :string(1)        indexed
#  Grade     :integer          indexed
#  ID        :integer          not null, primary key
#  Location  :integer          default(0), not null, indexed
#  Num       :integer          uniquely indexed => [Date], indexed
#  Purse     :bigint
#  RaceName  :string(50)       indexed
#  SplitType :string           default("2F"), not null
#  Time      :string(10)       indexed
#  Type      :integer          default(0), not null, indexed, indexed => [Date]
#
# Indexes
#
#  Age        (Age)
#  Date       (Date)
#  Distance   (Distance)
#  Gender     (Gender)
#  Grade      (Grade)
#  Location   (Location)
#  Num_Date   (Num,Date) UNIQUE
#  RaceName   (RaceName)
#  RaceNum    (Num)
#  Surface    (Condition)
#  Time       (Time)
#  Type       (Type)
#  Type_Date  (Type,Date)
#

