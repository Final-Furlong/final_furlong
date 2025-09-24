module Legacy
  class Activity < Record
    self.table_name = "ff_activity"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_activity
#
#  Date    :date
#  ID      :integer          not null, primary key
#  Stable  :integer          indexed
#  Type    :integer          default(0), not null
#  amount  :integer
#  balance :integer
#  budget  :integer
#
# Indexes
#
#  Stable  (Stable)
#

