module Legacy
  class BreedRanking < Record
    self.table_name = "ff_breed_rankings"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_breed_rankings
# Database name: legacy
#
#  ID      :integer          not null, primary key
#  MinPts  :integer          not null
#  Ranking :string(25)       not null
#

