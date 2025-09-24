module Legacy
  class UserWarning < Record
    self.table_name = "ff_userwarnings"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_userwarnings
#
#  DateFulfilled :date
#  DateGiven     :date
#  ID            :integer          not null, primary key
#  Type          :string(255)
#  User          :integer
#

