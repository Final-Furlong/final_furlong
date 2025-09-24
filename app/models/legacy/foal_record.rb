module Legacy
  class FoalRecord < Record
    self.table_name = "ff_foalrecords"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_foalrecords
#
#  DC        :string           default("B"), not null, indexed
#  Earnings  :integer          default(0), not null
#  FlatSC    :string           default("F"), not null
#  Fourths   :integer          default(0), not null
#  Horse     :integer          default(0), not null, indexed
#  ID        :integer          not null, primary key
#  Points    :integer          default(0), not null
#  Seconds   :integer          default(0), not null
#  Stakes    :integer          default(0), not null
#  StakesFs  :integer          default(0), not null
#  StakesSds :integer          default(0), not null
#  StakesTds :integer          default(0), not null
#  StakesWn  :integer          default(0), not null
#  Starts    :integer          default(0), not null
#  Thirds    :integer          default(0), not null
#  Wins      :integer          default(0), not null
#
# Indexes
#
#  DC     (DC)
#  Horse  (Horse)
#

