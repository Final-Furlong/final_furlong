module Legacy
  class ColorWarScore < Record
    self.table_name = "ff_cw_scores"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_cw_scores
#
#  Activity    :integer          not null
#  Date        :datetime         not null
#  Description :string(255)
#  ID          :integer          not null, primary key
#  Points      :integer          not null
#  Team        :integer          not null
#

