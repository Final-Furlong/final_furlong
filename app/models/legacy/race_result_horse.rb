module Legacy
  class RaceResultHorse < Record
    self.table_name = "ff_raceresults_oof"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_raceresults_oof
# Database name: legacy
#
#  Equip     :integer          indexed
#  Fractions :string(255)
#  Horse     :string(255)      not null, indexed, indexed => [RaceID], indexed => [RaceID], indexed => [Pos]
#  ID        :integer          not null, primary key
#  Jockey    :integer
#  MarL      :string(150)      not null
#  Odds      :integer
#  PP        :integer          not null
#  Pos       :integer          default(0), not null, indexed, indexed => [Horse]
#  RL        :string(50)       not null
#  RaceID    :integer          indexed => [Horse], indexed => [Horse], indexed
#  SF        :integer          default(0), not null
#  Weight    :integer
#
# Indexes
#
#  Equip           (Equip)
#  Horse           (Horse)
#  Horse_Race      (Horse,RaceID)
#  Pos             (Pos)
#  RaceID          (RaceID,Horse)
#  RaceNum         (RaceID)
#  position_horse  (Pos,Horse)
#

