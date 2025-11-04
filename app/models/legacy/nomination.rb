module Legacy
  class Nomination < Record
    self.table_name = "ff_nominations"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_nominations
# Database name: legacy
#
#  Horse :integer          default(0), not null, indexed => [Race], uniquely indexed => [Race, Year]
#  ID    :integer          not null, primary key
#  Race  :integer          default(0), not null, indexed, indexed => [Horse], uniquely indexed => [Horse, Year]
#  Year  :integer          uniquely indexed => [Race, Horse]
#
# Indexes
#
#  Race             (Race)
#  Race_Horse       (Race,Horse)
#  Race_Horse_Year  (Race,Horse,Year) UNIQUE
#

