module Legacy
  class HorseEvent < Record
    self.table_name = "ff_horse_events"
  end
end

# == Schema Information
#
# Table name: ff_horse_events
#
#  id    :integer          not null, primary key
#  event :string(255)      not null
#

