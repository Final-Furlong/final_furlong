module Legacy
  class HorseColor < Record
    self.table_name = "ff_horse_colors"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_horse_colors
#
#  Abbr  :string(5)        not null
#  Color :string(255)      not null
#  ID    :integer          not null, primary key
#

