module Legacy
  class PendingRetirement < Record
    self.table_name = "pending_retirements"
  end
end

# == Schema Information
#
# Table name: pending_retirements
#
#  id         :integer          unsigned, not null, primary key
#  created_at :datetime
#  horse_id   :integer
#

