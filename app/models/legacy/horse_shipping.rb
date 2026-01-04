module Legacy
  class HorseShipping < Record
    self.table_name = "ff_horse_shipping"
    self.primary_key = "ID"

    belongs_to :horse, class_name: "Legacy::Horse", foreign_key: "Horse"
  end
end

# == Schema Information
#
# Table name: ff_horse_shipping
# Database name: legacy
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

