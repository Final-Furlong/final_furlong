module Legacy
  class ColorWarEntry < Record
    self.table_name = "ff_cw_entries"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_cw_entries
# Database name: legacy
#
#  Date   :datetime         not null
#  Horse  :integer          not null, uniquely indexed => [Race]
#  ID     :integer          not null, primary key
#  Member :integer          not null
#  Race   :integer          not null, uniquely indexed => [Horse]
#  Team   :integer          not null
#
# Indexes
#
#  Horse  (Horse,Race) UNIQUE
#

