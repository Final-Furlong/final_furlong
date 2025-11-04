module Legacy
  class Skin < Record
    self.table_name = "ff_skins"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_skins
# Database name: legacy
#
#  Active          :boolean          default(FALSE), not null
#  BackgroundImage :string(200)
#  Description     :text(65535)      not null
#  ID              :integer          not null, primary key
#  MenuLink        :string(6)        default("000"), not null
#  PageBackground  :string(6)        not null
#  Skin            :string(255)      not null
#  TableHead       :string(6)        not null
#  TableRow1       :string(6)        not null
#  TableRow2       :string(6)        not null
#

