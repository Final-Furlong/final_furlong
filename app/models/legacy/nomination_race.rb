module Legacy
  class NominationRace < Record
    self.table_name = "ff_nomraces"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_nomraces
#
#  2yo      :integer          unsigned
#  3yo      :integer          unsigned
#  3yo+     :integer          unsigned
#  4yo+     :integer          unsigned
#  ID       :integer          unsigned, not null, primary key
#  Period   :string(1)        default("A"), not null
#  Race     :integer          default(0), unsigned, not null, indexed
#  Weanling :integer          unsigned
#  Yearling :integer          unsigned
#
# Indexes
#
#  Race  (Race)
#

