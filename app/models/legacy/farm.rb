module Legacy
  class Farm < Record
    self.table_name = "ff_farms"
  end
end

# == Schema Information
#
# Table name: ff_farms
#
#  id       :integer          not null, primary key
#  track_id :integer          not null, uniquely indexed
#
# Indexes
#
#  track_id  (track_id) UNIQUE
#

