module Legacy
  class Activity < Record
    self.table_name = "ff_activity"
    self.primary_key = "ID"

    scope :recent, -> { order(Date: :desc, ID: :desc) }

    def self.create_new(legacy_id:, points:, budget_id: nil)
      activity = where(Stable: legacy_id).recent.first
      initial_amount = activity&.amount.to_i
      stable = Account::Stable.find_by(legacy_id:)
      new_points = stable&.newbie? ? points * 2 : points
      Legacy::Activity.create!(
        Date: Date.current,
        Stable: legacy_id,
        Type: 4,
        amount: new_points,
        balance: initial_amount + new_points,
        budget: budget_id
      )
    end

    def lookup_methods
      %w[Date ID Stable Type amount balance budget]
    end
  end
end

# == Schema Information
#
# Table name: ff_activity
#
#  Date    :date
#  ID      :integer          not null, primary key
#  Stable  :integer          indexed
#  Type    :integer          default(0), not null
#  amount  :integer
#  balance :integer
#  budget  :integer
#
# Indexes
#
#  Stable  (Stable)
#

