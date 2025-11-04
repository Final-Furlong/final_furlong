module Legacy
  class Pedigree < Record
    self.table_name = "ff_pedigrees"
  end
end

# == Schema Information
#
# Table name: ff_pedigrees
# Database name: legacy
#
#  id        :integer          not null, primary key
#  dam       :string(18)       not null
#  dam_dam   :string(18)       not null
#  dam_sire  :string(18)       not null
#  gender    :string           not null
#  horse     :string(18)       not null, uniquely indexed
#  sire      :string(18)       not null
#  sire_dam  :string(18)       not null
#  sire_sire :string(18)       not null
#  user_id   :integer          not null
#
# Indexes
#
#  horse  (horse) UNIQUE
#

