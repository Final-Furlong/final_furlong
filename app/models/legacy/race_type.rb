module Legacy
  class RaceType < Record
    self.table_name = "ff_race_types"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_race_types
#
#  ID   :integer          not null, primary key
#  Type :string(50)       not null, indexed
#
# Indexes
#
#  type  (Type)
#

