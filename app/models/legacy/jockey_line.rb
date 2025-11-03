module Legacy
  class JockeyLine < Record
    self.table_name = "ff_jocklines"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_jocklines
# Database name: legacy
#
#  ID    :integer          not null, primary key
#  Line  :string(255)      not null
#  Stat  :string(255)      not null, indexed => [Value]
#  Value :integer          indexed => [Stat]
#
# Indexes
#
#  stat_search  (Stat,Value)
#

