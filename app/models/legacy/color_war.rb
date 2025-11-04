module Legacy
  class ColorWar < Record
    self.table_name = "ff_colorwar"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_colorwar
# Database name: legacy
#
#  Activity :string(255)
#  ID       :integer          not null, primary key
#  Points   :integer          default(0), not null
#  PtsAvail :integer          default(0), not null
#  Team     :integer          default(0), not null
#

