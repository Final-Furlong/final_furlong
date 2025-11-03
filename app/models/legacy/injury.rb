module Legacy
  class Injury < Record
    self.table_name = "ff_injuries"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_injuries
# Database name: legacy
#
#  Date    :date
#  Horse   :integer          default(0), not null
#  ID      :integer          not null, primary key
#  Injury  :integer
#  Rest    :date
#  VetDate :date
#

