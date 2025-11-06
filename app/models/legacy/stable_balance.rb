module Legacy
  class StableBalance < Record
    self.table_name = "ff_stables"
    self.primary_key = "id"
  end
end

# == Schema Information
#
# Table name: ff_stables
# Database name: legacy
#
#  id               :integer          not null, primary key
#  availableBalance :integer          default(0)
#  date             :datetime         not null
#  slug             :string(255)
#  totalBalance     :integer          default(0)
#

