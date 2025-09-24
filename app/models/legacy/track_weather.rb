module Legacy
  class TrackWeather < Record
    self.table_name = "ff_track_weather"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_track_weather
#
#  FFast :integer          not null
#  FGood :integer          not null
#  FSlow :integer          not null
#  FWet  :integer          not null
#  ID    :integer          not null, primary key
#  SFast :integer          not null
#  SGood :integer          not null
#  SSlow :integer          not null
#  SWet  :integer          not null
#  UFast :integer          not null
#  UGood :integer          not null
#  USlow :integer          not null
#  UWet  :integer          not null
#  WFast :integer          not null
#  WGood :integer          not null
#  WSlow :integer          not null
#  WWet  :integer          not null
#

