module Legacy
  class TripleCrownWinner < Record
    self.table_name = "ff_tcbs_winners"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_tcbs_winners
# Database name: legacy
#
#  ID     :integer          not null, primary key
#  TCBS   :string(2)        not null
#  Title  :string(50)       not null, indexed
#  Winner :integer          default(0), not null
#  Year   :integer          default(0), not null
#
# Indexes
#
#  Title  (Title)
#

