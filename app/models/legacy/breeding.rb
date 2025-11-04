module Legacy
  class Breeding < Record
    self.table_name = "ff_breedings"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_breedings
# Database name: legacy
#
#  CustomFee    :integer          default(0)
#  Date         :date
#  Due          :date
#  ID           :integer          not null, primary key
#  Mare         :integer          default(0), not null, indexed
#  MareComments :string(255)
#  Owner        :integer          default(0), not null
#  Status       :string(1)        default("P"), not null
#  Stud         :integer          indexed
#  StudComments :string(255)
#
# Indexes
#
#  Mare  (Mare)
#  Stud  (Stud)
#

