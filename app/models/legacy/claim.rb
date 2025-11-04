module Legacy
  class Claim < Record
    self.table_name = "ff_claims"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_claims
# Database name: legacy
#
#  Claimer :integer          indexed, uniquely indexed => [RaceDay]
#  Date    :date
#  Horse   :integer          indexed
#  ID      :integer          not null, primary key
#  Owner   :integer
#  Price   :integer
#  RaceDay :date             uniquely indexed => [Claimer]
#  RaceNum :integer
#
# Indexes
#
#  Claimer  (Claimer)
#  RaceDay  (RaceDay,Claimer) UNIQUE
#  horse    (Horse)
#

