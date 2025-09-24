module Legacy
  class ActivityPoint < Record
    self.table_name = "ff_activity_pts"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_activity_pts
#
#  1stYearPts :integer          default(0), not null
#  2ndYearPts :integer          default(0), not null
#  ID         :integer          not null, primary key
#  Keyword    :string(50)       not null
#  OtherPts   :integer          default(0), not null
#

