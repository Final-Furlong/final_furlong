module Legacy
  class JockeyStatus < Record
    self.table_name = "ff_jockey_status"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_jockey_status
#
#  ID     :integer          not null, primary key
#  Status :string(255)      not null
#

