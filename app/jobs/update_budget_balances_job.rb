class UpdateBudgetBalancesJob < ApplicationJob
  queue_as :default

  include ActiveJob::Continuable

  def perform
    step :update_all_stables, start: [nil, nil] do |step|
      Account::Stable.find_each(start: step.cursor[0]) do |stable|
        balance = 0
        Account::Budget.where(stable:).order(created_at: :asc).find_each(start: step.cursor[1]) do |budget|
          balance += budget.amount
          budget.assign_attributes(balance:)
          budget.save(validate: false)
          step.set! [stable.id, budget.id + 1]
        end
        stable.update(total_balance: balance)
        step.set! [stable.id + 1, nil]
      end
    end

    step :notify do |step|
      User::SendDeveloperNotifications.call(title: "Budget Update", message: "Budget balances job finished")
    end
  end
end

