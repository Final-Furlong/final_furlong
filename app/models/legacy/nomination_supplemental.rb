module Legacy
  class NominationSupplemental < Record
    self.table_name = "ff_nominations_sup"
  end
end

# == Schema Information
#
# Table name: ff_nominations_sup
#
#  id    :integer          not null, primary key
#  horse :integer          not null
#  race  :integer          not null, indexed
#  year  :integer          not null, indexed
#
# Indexes
#
#  race  (race)
#  year  (year)
#

