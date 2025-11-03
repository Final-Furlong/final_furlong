module Legacy
  class ColorWarActivity < Record
    self.table_name = "ff_cw_activities"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_cw_activities
# Database name: legacy
#
#  Activity :string(255)      not null
#  End      :datetime         default(NULL), not null
#  ID       :integer          not null, primary key
#  Start    :datetime         not null
#

