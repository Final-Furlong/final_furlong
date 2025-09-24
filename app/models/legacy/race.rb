module Legacy
  class Race < Record
    self.table_name = "ff_races"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_races
#
#  Age      :integer          not null, indexed
#  Date     :date             default(NULL), not null, indexed
#  DayNum   :integer          not null
#  Distance :float(53)        not null, indexed
#  Gender   :string(1)
#  Grade    :integer          indexed
#  ID       :integer          not null, primary key
#  Location :integer          not null, indexed, indexed
#  Name     :string(255)      indexed
#  Num      :integer          indexed
#  Purse    :bigint           indexed
#  Type     :integer          not null, indexed
#
# Indexes
#
#  Age       (Age)
#  Date      (Date)
#  Distance  (Distance)
#  Grade     (Grade)
#  Num       (Num)
#  Purse     (Purse)
#  Race      (Name)
#  Track     (Location)
#  location  (Location)
#  type      (Type)
#

