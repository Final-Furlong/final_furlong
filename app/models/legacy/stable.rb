module Legacy
  class Stable < Record
    self.table_name = "ff_stables"

    def self.update_balance(id:, amount:)
      record = find_or_initialize_by(id:)
      record.update(
        date: Date.current + 4.years,
        totalBalance: record.totalBalance.to_i + amount,
        availableBalance: record.availableBalance.to_i + amount
      )
    end

    def lookup_methods
      %w[id availableBalance totalBalance date slug]
    end
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

