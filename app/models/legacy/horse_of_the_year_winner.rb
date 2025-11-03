module Legacy
  class HorseOfTheYearWinner < Record
    self.table_name = "ff_hoty_winners"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_hoty_winners
# Database name: legacy
#
#  Category :integer          default(0), not null, indexed
#  ID       :integer          not null, primary key
#  Winner   :integer          default(0), not null
#  Year     :integer          default(0), not null
#
# Indexes
#
#  Category  (Category)
#

