module Legacy
  class FutureEvent < Record
    self.table_name = "ff_futureevents"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_futureevents
#
#  Date  :date             indexed => [Event]
#  Event :string(255)      indexed => [Date]
#  Horse :integer
#  ID    :integer          not null, primary key
#
# Indexes
#
#  event_search  (Event,Date)
#

