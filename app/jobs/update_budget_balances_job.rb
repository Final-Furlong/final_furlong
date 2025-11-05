class UpdateBudgetBalancesJob < ApplicationJob
  queue_as :default

  include ActiveJob::Continuable

  def perform
    step :update_all_stables do |step|
      Account::Stable.find_each(start: step.cursor) do |stable|
        balance = 0
        Account::Budget.where(stable:).order(created_at: :asc).find_each do |budget|
          balance += budget.amount
          budget.assign_attributes(balance:)
          budget.save(validate: false)
        end
        stable.update(total_balance: balance)
      end
    end

    step :notify do |step|
      User::SendDeveloperNotifications.call(title: "Budget Update", message: "Budget balances job finished")
    end
  end
end

