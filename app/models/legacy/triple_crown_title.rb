module Legacy
  class TripleCrownTitle < Record
    self.table_name = "ff_tcbs_titles"
    self.primary_key = "ID"
  end
end

# == Schema Information
#
# Table name: ff_tcbs_titles
# Database name: legacy
#
#  ID    :integer          not null, primary key
#  Title :string(255)      not null
#

