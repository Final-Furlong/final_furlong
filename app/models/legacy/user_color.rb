module Legacy
  class UserColor < Record
    self.table_name = "ff_user_colors"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_user_colors
# Database name: legacy
#
#  ID             :integer          not null, primary key
#  MenuLink       :string(6)        not null
#  PageBackground :string(6)        not null
#  TableHead      :string(6)        not null
#  TableRow1      :string(6)        not null
#  TableRow2      :string(6)        not null
#  User           :integer          not null
#

