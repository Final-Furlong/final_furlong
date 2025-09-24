module Legacy
  class TrackCondition < Record
    self.table_name = "ff_track_conditions"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_track_conditions
#
#  Condition :string(255)      not null
#  ID        :integer          not null, primary key
#

