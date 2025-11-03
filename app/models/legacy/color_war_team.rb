module Legacy
  class ColorWarTeam < Record
    self.table_name = "ff_cw_teams"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_cw_teams
# Database name: legacy
#
#  Captain :boolean          default(FALSE), not null
#  End     :datetime         default(NULL), not null
#  ID      :integer          not null, primary key
#  Member  :integer          not null, indexed
#  Start   :datetime         default(2012-02-19 19:00:00.000000000 UTC +00:00), not null
#  Team    :integer          not null
#
# Indexes
#
#  Member  (Member)
#

