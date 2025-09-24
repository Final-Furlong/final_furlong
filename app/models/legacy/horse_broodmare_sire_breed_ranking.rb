module Legacy
  class HorseBroodmareSireBreedRanking < Record
    self.table_name = "ff_horse_bsrankings"
    self.primary_key = "Horse"
  end
end

# == Schema Information
#
# Table name: ff_horse_bsrankings
#
#  Foals   :integer          default(0), not null
#  Horse   :integer          not null, primary key
#  Points  :integer          default(0), not null
#  Races   :integer          not null
#  Ranking :integer          not null
#

