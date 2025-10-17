module Accounts
  class ActivityTransactionCreator < ApplicationService
    def create_transaction(stable:, activity_type:, amount: nil, date: nil, budget: nil)
      previous_activity = Account::Activity.where(stable:).recent.first
      activity_field = if stable.newbie?
        :first_year_points
      elsif stable.second_year?
        :second_year_points
      else
        :older_year_points
      end
      amount = if amount.present?
        (activity_type == "redeem") ? amount.abs * -1 : amount.abs
      else
        Game::Activity.where(activity_type:).pick(activity_field)
      end

      if amount.to_i != 0
        attrs = {
          stable:,
          activity_type:,
          amount:,
          balance: (previous_activity&.balance || 0) + amount,
          legacy_stable_id: stable.legacy_id
        }
        attrs[:created_at] = date if date.present?
        attrs[:budget] = budget if budget.present?
        Account::Activity.create!(attrs)
      end
    end
  end
end

