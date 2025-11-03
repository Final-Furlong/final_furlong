module Legacy
  class HorseTitle < Record
    self.table_name = "ff_horse_titles"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_horse_titles
# Database name: legacy
#
#  Abbr   :string(10)       not null, indexed
#  ID     :integer          not null, primary key
#  Points :integer          not null, indexed
#  Title  :string(50)       not null, indexed
#
# Indexes
#
#  Abbr    (Abbr)
#  Points  (Points)
#  Title   (Title)
#

