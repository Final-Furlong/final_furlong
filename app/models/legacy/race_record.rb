module Legacy
  class RaceRecord < Record
    self.table_name = "ff_racerecords"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_racerecords
#
#  Earnings  :bigint           default(0), not null, indexed
#  FlatSC    :string           default("F"), not null, indexed, indexed => [Year]
#  Fourths   :integer          default(0), not null
#  Horse     :integer          default(0), not null, indexed, indexed => [Year]
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
#  Year      :integer          default(0), not null, indexed, indexed => [FlatSC], indexed => [Horse]
#
# Indexes
#
#  Earnings    (Earnings)
#  FlatSC      (FlatSC)
#  Horse       (Horse)
#  Points      (Points)
#  StakesWn    (StakesWn)
#  Year        (Year)
#  Year_FSC    (Year,FlatSC)
#  wins        (Wins)
#  year_horse  (Year,Horse)
#

