module Legacy
  class HorseBreedRanking < Record
    self.table_name = "ff_horse_brankings"
    self.primary_key = "Horse"

    scope :bronze, -> { where(Ranking: 1) }
    scope :silver, -> { where(Ranking: 2) }
    scope :gold, -> { where(Ranking: 3) }
    scope :platinum, -> { where(Ranking: 4) }
  end
end

# == Schema Information
#
# Table name: ff_horse_brankings
#
#  Foals   :integer          default(0), not null
#  Horse   :integer          not null, primary key
#  Points  :integer          default(0), not null, indexed
#  Races   :integer          not null
#  Ranking :integer          not null, indexed
#
# Indexes
#
#  idx_points   (Points)
#  idx_ranking  (Ranking)
#

