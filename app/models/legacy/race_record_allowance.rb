module Legacy
  class RaceRecordAllowance < Record
    self.table_name = "ff_racerecords_allowance"
  end
end

# == Schema Information
#
# Table name: ff_racerecords_allowance
# Database name: legacy
#
#  id    :integer          not null, primary key
#  horse :integer          default(0), not null, uniquely indexed
#  wins  :integer          default(0), not null, indexed
#
# Indexes
#
#  Horse  (horse) UNIQUE
#  wins   (wins)
#

