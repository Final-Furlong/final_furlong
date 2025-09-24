module Legacy
  class HorseStatus < Record
    self.table_name = "ff_horse_status"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_horse_status
#
#  ID     :integer          not null, primary key
#  Status :string(255)      not null, indexed
#
# Indexes
#
#  Status  (Status)
#

