module Legacy
  class ColorWarRaceVote < Record
    self.table_name = "ff_cw_race_votes"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_cw_race_votes
# Database name: legacy
#
#  Date   :datetime         not null
#  Entry  :integer          not null
#  ID     :integer          not null, primary key
#  Member :integer          not null
#  Team   :integer          not null
#  Vote   :boolean          not null
#

