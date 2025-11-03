module Legacy
  class AutoEntryStatus < Record
    self.table_name = "auto_entry_status"
  end
end

# == Schema Information
#
# Table name: auto_entry_status
# Database name: legacy
#
#  id        :integer          not null, primary key
#  race_date :date             uniquely indexed => [horse_id]
#  race_num  :integer          default(0), not null
#  status    :string(255)      indexed
#  horse_id  :integer          not null, uniquely indexed => [race_date]
#  user_id   :integer          not null, indexed
#
# Indexes
#
#  horse_id  (horse_id,race_date) UNIQUE
#  status    (status)
#  user_id   (user_id)
#

