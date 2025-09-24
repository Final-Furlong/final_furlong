module Legacy
  class HorseMarking < Record
    self.table_name = "ff_horse_markings"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_horse_markings
#
#  ID      :integer          not null, primary key
#  Marking :string(255)      not null
#

