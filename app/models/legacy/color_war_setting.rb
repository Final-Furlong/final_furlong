module Legacy
  class ColorWarSetting < Record
    self.table_name = "ff_cw_settings"
  end
end

# == Schema Information
#
# Table name: ff_cw_settings
#
#  id    :integer          not null, primary key
#  name  :string(255)      not null
#  value :string(255)      not null
#

