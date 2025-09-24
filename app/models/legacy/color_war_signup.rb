module Legacy
  class ColorWarSignup < Record
    self.table_name = "ff_cw_signups"
  end
end

# == Schema Information
#
# Table name: ff_cw_signups
#
#  id      :integer          not null, primary key
#  captain :integer          not null
#  date    :date             not null
#  year    :integer          not null
#  user_id :integer          not null
#

