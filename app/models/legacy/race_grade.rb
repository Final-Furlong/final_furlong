module Legacy
  class RaceGrade < Record
    self.table_name = "ff_race_grades"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_race_grades
#
#  Abbr  :string(5)        not null
#  Grade :string(50)       not null
#  ID    :integer          not null, primary key
#

