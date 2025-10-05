module Legacy
  class Stable < Record
    self.table_name = "ff_stables"
  end
end

# == Schema Information
#
# Table name: ff_stables
#
#  id               :integer          not null, primary key
#  availableBalance :integer          default(0)
#  date             :datetime         not null
#  slug             :string(255)
#  totalBalance     :integer          default(0)
#

