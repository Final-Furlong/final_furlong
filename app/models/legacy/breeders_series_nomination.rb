module Legacy
  class BreedersSeriesNomination < Record
    self.table_name = "ff_nom_bs"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_nom_bs
# Database name: legacy
#
#  BS     :integer          default(0), not null, indexed
#  ID     :integer          not null, primary key
#  Stable :integer          default(0), not null
#
# Indexes
#
#  series  (BS)
#

