module Legacy
  class SpeedRecord < Record
    self.table_name = "ff_speedrecords"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_speedrecords
# Database name: legacy
#
#  Distance :float(53)        indexed
#  Gender   :string(50)       indexed
#  Horse    :string(25)       default("0"), not null, indexed
#  ID       :integer          not null, primary key
#  NewRec   :string(1)        not null
#  RaceID   :integer          default(0), not null, indexed
#  Time     :string(50)       not null, indexed
#  Track    :string(50)       indexed
#
# Indexes
#
#  Distance  (Distance)
#  Gender    (Gender)
#  Horse     (Horse)
#  RaceID    (RaceID)
#  Time      (Time)
#  Track     (Track)
#

