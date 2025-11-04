module Legacy
  class Equipment < Record
    self.table_name = "ff_equipment"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_equipment
# Database name: legacy
#
#  Equipment :string(20)       indexed
#  ID        :integer          not null, primary key
#
# Indexes
#
#  equipment  (Equipment)
#

