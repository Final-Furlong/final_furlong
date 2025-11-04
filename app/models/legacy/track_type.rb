module Legacy
  class TrackType < Record
    self.table_name = "ff_track_types"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_track_types
# Database name: legacy
#
#  ID   :integer          not null, primary key
#  Type :string(255)      not null
#

