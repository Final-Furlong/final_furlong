module Legacy
  class HorseLatestClaimingRace < Record
    self.table_name = "ff_horse_latest_claiming_race"
  end
end

# == Schema Information
#
# Table name: ff_horse_latest_claiming_race
#
#  id      :integer          not null, primary key
#  date    :date             not null
#  horse   :integer          not null, uniquely indexed
#  race_id :integer          not null, indexed
#
# Indexes
#
#  Horse  (horse) UNIQUE
#  race   (race_id)
#

