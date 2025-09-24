module Legacy
  class RaceAge < Record
    self.table_name = "ff_race_ages"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_race_ages
#
#  Age :string(10)       not null
#  ID  :integer          not null, primary key
#

