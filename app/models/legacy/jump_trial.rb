module Legacy
  class JumpTrial < Record
    self.table_name = "ff_sctrials"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_sctrials
#
#  Comment   :integer          not null
#  Condition :integer          not null, indexed => [Horse, Jockey, Location]
#  Date      :date             not null
#  Distance  :integer          default(0), not null
#  Horse     :integer          default(0), not null, indexed => [Jockey, Condition, Location]
#  ID        :integer          not null, primary key
#  Jockey    :integer          default(0), not null, indexed => [Horse, Condition, Location]
#  Location  :integer          default(0), not null, indexed => [Horse, Jockey, Condition]
#  Time      :string(10)
#
# Indexes
#
#  Horse  (Horse,Jockey,Condition,Location)
#

