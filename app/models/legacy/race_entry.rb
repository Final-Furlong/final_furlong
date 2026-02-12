module Legacy
  class RaceEntry < Record
    self.table_name = "ff_raceentries"
    self.primary_key = "ID"

    belongs_to :race, class_name: "Legacy::Race", foreign_key: :Race
    belongs_to :horse, class_name: "Legacy::Horse", foreign_key: :Horse
  end
end

# == Schema Information
#
# Table name: ff_raceentries
# Database name: legacy
#
#  EntryDate    :datetime         not null
#  Equipment    :integer          indexed
#  Horse        :integer          default(0), not null, indexed, uniquely indexed => [Race]
#  ID           :integer          not null, primary key
#  Instructions :integer
#  Jock2        :integer
#  Jock3        :integer
#  Jockey       :integer
#  Odds         :integer
#  PP           :integer
#  Race         :integer          default(0), not null, indexed, uniquely indexed => [Horse]
#  Weight       :integer
#
# Indexes
#
#  Horse       (Horse)
#  equipment   (Equipment)
#  race        (Race)
#  race_horse  (Race,Horse) UNIQUE
#

