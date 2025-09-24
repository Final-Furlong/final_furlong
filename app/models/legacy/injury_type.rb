module Legacy
  class InjuryType < Record
    self.table_name = "ff_injury_types"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_injury_types
#
#  ID     :integer          not null, primary key
#  Injury :string(50)       not null
#  Line   :string(255)      not null
#

