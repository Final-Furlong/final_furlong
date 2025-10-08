module Legacy
  class Budget < Record
    self.table_name = "ff_budgets"
    self.primary_key = "ID"

    scope :recent, -> { order(Date: :desc, ID: :desc) }

    def self.create_new(legacy_id:, description:, amount:)
      previous_budget = where(Stable: legacy_id).recent.first
      Legacy::Budget.create!(
        Stable: legacy_id,
        Date: Date.current + 4.years,
        Description: description,
        Amount: amount,
        Balance: previous_budget&.balance.to_i + amount
      )
    end
  end
end

# == Schema Information
#
# Table name: ff_budgets
#
#  Amount      :integer
#  Balance     :integer
#  Date        :date             indexed, indexed => [Stable, Description]
#  Description :string(255)      indexed, indexed => [Stable, Date], indexed => [Stable]
#  ID          :integer          not null, primary key
#  Stable      :integer          indexed, indexed => [Date, Description], indexed => [Description]
#
# Indexes
#
#  Date                     (Date)
#  Stable                   (Stable)
#  description              (Description)
#  stable_date_description  (Stable,Date,Description)
#  stable_description       (Stable,Description)
#

