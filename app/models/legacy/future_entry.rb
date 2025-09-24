module Legacy
  class FutureEntry < Record
    self.table_name = "ff_futureentries"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_futureentries
#
#  AutoEnter    :boolean          default(FALSE), not null
#  AutoShip     :boolean          default(FALSE), not null
#  DateEntered  :datetime         not null
#  Equipment    :integer
#  Horse        :integer          default(0), not null, uniquely indexed => [Race]
#  ID           :integer          not null, primary key
#  Instructions :integer
#  Jock2        :integer
#  Jock3        :integer
#  Jockey       :integer
#  Race         :integer          default(0), not null, uniquely indexed => [Horse]
#  RaceDate     :date
#  ShipMethod   :string           default("R"), not null
#
# Indexes
#
#  HorseRace  (Horse,Race) UNIQUE
#

