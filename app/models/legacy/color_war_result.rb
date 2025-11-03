module Legacy
  class ColorWarResult < Record
    self.table_name = "ff_cw_results"
  end
end

# == Schema Information
#
# Table name: ff_cw_results
# Database name: legacy
#
#  id       :integer          not null, primary key
#  position :integer          not null
#  year     :string(4)        not null, uniquely indexed => [user_id]
#  user_id  :integer          not null, uniquely indexed => [year]
#
# Indexes
#
#  year  (year,user_id) UNIQUE
#

