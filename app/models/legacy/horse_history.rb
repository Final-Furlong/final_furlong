module Legacy
  class HorseHistory < Record
    self.table_name = "ff_horse_history"
  end
end

# == Schema Information
#
# Table name: ff_horse_history
# Database name: legacy
#
#  id      :integer          not null, primary key
#  date    :datetime         not null, uniquely indexed => [horseId, eventId]
#  eventId :integer          not null, uniquely indexed => [horseId, date]
#  horseId :integer          not null, uniquely indexed => [eventId, date]
#  value   :string(255)
#
# Indexes
#
#  horseId  (horseId,eventId,date) UNIQUE
#

