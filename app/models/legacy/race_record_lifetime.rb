module Legacy
  class RaceRecordLifetime < Record
    self.table_name = "ff_racerecords_lifetime"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_racerecords_lifetime
#
#  Earnings  :integer          default(0), not null, indexed
#  Fourths   :integer          default(0), not null
#  Horse     :integer          default(0), not null, uniquely indexed
#  ID        :integer          not null, primary key
#  Points    :integer          default(0), not null, indexed
#  Seconds   :integer          default(0), not null
#  Stakes    :integer          default(0), not null
#  StakesFs  :integer          default(0), not null
#  StakesSds :integer          default(0), not null
#  StakesTds :integer          default(0), not null
#  StakesWn  :integer          default(0), not null, indexed
#  Starts    :integer          default(0), not null
#  Thirds    :integer          default(0), not null
#  Wins      :integer          default(0), not null, indexed
#
# Indexes
#
#  Earnings  (Earnings)
#  Horse     (Horse) UNIQUE
#  Points    (Points)
#  StakesWn  (StakesWn)
#  wins      (Wins)
#

