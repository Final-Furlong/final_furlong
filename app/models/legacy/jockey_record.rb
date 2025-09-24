module Legacy
  class JockeyRecord < Record
    self.table_name = "ff_jockey_records"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_jockey_records
#
#  Earnings  :integer          default(0), not null
#  Fourths   :integer          default(0), not null
#  ID        :integer          not null, primary key
#  Jockey    :integer          not null
#  Seconds   :integer          default(0), not null
#  Stakes    :integer          default(0), not null
#  StakesFs  :integer          default(0), not null
#  StakesSds :integer          default(0), not null
#  StakesTds :integer          default(0), not null
#  StakesWn  :integer          default(0), not null
#  Starts    :integer          default(0), not null
#  Thirds    :integer          default(0), not null
#  Wins      :integer          default(0), not null
#  Year      :integer          not null
#

