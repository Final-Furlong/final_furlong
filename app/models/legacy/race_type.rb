module Legacy
  class RaceType < Record
    self.table_name = "ff_race_types"
    self.primary_key = "ID"

    scope :claiming, -> { where("#{Legacy::RaceType.arel_table.name}.Type LIKE ?", "Claiming%") }

    def lookup_methods
      %w[ID Type]
    end
  end
end

# == Schema Information
#
# Table name: ff_race_types
# Database name: legacy
#
#  ID   :integer          not null, primary key
#  Type :string(50)       not null, indexed
#
# Indexes
#
#  type  (Type)
#

