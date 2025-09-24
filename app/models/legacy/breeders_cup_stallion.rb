module Legacy
  class BreedersCupStallion < Record
    self.table_name = "ff_bcstuds"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_bcstuds
#
#  ID   :integer          not null, primary key
#  Stud :integer          indexed
#  Year :integer          default(0), not null
#
# Indexes
#
#  Stud  (Stud)
#

