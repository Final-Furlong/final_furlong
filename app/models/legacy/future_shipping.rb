module Legacy
  class FutureShipping < Record
    self.table_name = "ff_futureshipping"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_futureshipping
# Database name: legacy
#
#  Date                         :date             not null, uniquely indexed => [Horse, ToTrack]
#  Horse                        :integer          not null, uniquely indexed => [ToTrack, Date]
#  ID                           :integer          not null, primary key
#  Mode(* = choose best method) :string           default("R"), not null
#  RaceLink                     :integer
#  Status                       :string           default("S"), not null
#  ToFarm                       :integer
#  ToTrack                      :integer          uniquely indexed => [Horse, Date]
#
# Indexes
#
#  Horse  (Horse,ToTrack,Date) UNIQUE
#

