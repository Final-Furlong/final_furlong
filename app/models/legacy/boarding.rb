module Legacy
  class Boarding < Record
    self.table_name = "ff_boarding"
  end
end

# == Schema Information
#
# Table name: ff_boarding
# Database name: legacy
#
#  id         :integer          not null, primary key
#  days       :integer          not null
#  end_date   :date             indexed, indexed => [horse_id]
#  start_date :date             not null, indexed, uniquely indexed => [horse_id, farm_id]
#  farm_id    :integer          not null, indexed, uniquely indexed => [horse_id, start_date]
#  horse_id   :integer          not null, indexed => [end_date], indexed, uniquely indexed => [farm_id, start_date]
#
# Indexes
#
#  end_date         (end_date)
#  farm_id          (farm_id)
#  horse_end_date   (horse_id,end_date)
#  horse_id         (horse_id)
#  start_date       (start_date)
#  unique_boarding  (horse_id,farm_id,start_date) UNIQUE
#

