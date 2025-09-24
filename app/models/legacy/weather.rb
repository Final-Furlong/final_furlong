module Legacy
  class Weather < Record
    self.table_name = "ff_weather"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_weather
#
#  Condition :integer          not null
#  Day       :integer          not null
#  ID        :integer          not null, primary key
#  Rain      :integer          not null
#  Track     :integer          not null
#

