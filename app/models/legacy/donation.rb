module Legacy
  class Donation < Record
    self.table_name = "ff_donations"
    self.primary_key = "txn_id"
  end
end

# == Schema Information
#
# Table name: ff_donations
# Database name: legacy
#
#  amount  :float(24)        not null
#  date    :date             not null
#  txn_id  :string(19)       not null, primary key
#  user_id :integer          not null
#

