module Legacy
  class HorseShipping < Record
    self.table_name = "ff_horse_shipping"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_horse_shipping
#
#  Arrive    :date             not null
#  Date      :date             not null, indexed
#  FromFarm  :integer
#  FromTrack :integer
#  Horse     :integer          not null, indexed
#  ID        :integer          not null, primary key
#  Mode      :string           not null
#  ToFarm    :integer
#  ToTrack   :integer
#
# Indexes
#
#  Date   (Date)
#  Horse  (Horse)
#

