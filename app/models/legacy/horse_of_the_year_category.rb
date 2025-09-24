module Legacy
  class HorseOfTheYearCategory < Record
    self.table_name = "ff_hoty_cats"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_hoty_cats
#
#  ID   :integer          not null, primary key
#  Name :string(255)      not null, uniquely indexed
#
# Indexes
#
#  name  (Name) UNIQUE
#

