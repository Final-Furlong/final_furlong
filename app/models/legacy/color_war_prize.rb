module Legacy
  class ColorWarPrize < Record
    self.table_name = "ff_cw_prizes"
  end
end

# == Schema Information
#
# Table name: ff_cw_prizes
# Database name: legacy
#
#  id      :integer          not null, primary key
#  type    :integer          not null
#  value   :integer          not null
#  year    :string(4)        not null
#  user_id :integer          not null
#

