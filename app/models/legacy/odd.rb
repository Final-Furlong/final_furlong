module Legacy
  class Odd < Record
    self.table_name = "ff_odds"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_odds
# Database name: legacy
#
#  Dec  :float(53)        not null
#  ID   :integer          not null, primary key
#  Odds :string(5)        not null
#

