module Legacy
  class HorseInjury < Record
    self.table_name = "ff_horse_injuries"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_horse_injuries
# Database name: legacy
#
#  Date   :date             not null, indexed, indexed => [Horse], indexed => [Horse]
#  Horse  :integer          not null, indexed, indexed => [Injury], indexed => [Date], indexed => [Date]
#  ID     :integer          not null, primary key
#  Injury :integer          not null, indexed => [Horse], indexed
#  Leg    :string(2)
#
# Indexes
#
#  Date        (Date)
#  Horse       (Horse)
#  Horse_2     (Horse,Injury)
#  Injury      (Injury)
#  date_horse  (Date,Horse)
#  horse_date  (Horse,Date)
#

