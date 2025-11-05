class UpdateBudgetTimestampsJob < ApplicationJob
  queue_as :default

  include ActiveJob::Continuable

  def perform
    step :update_all_stables do |step|
      Account::Stable.find_each(start: step.cursor) do |stable|
        budget_days = Account::Budget.where(stable:).group(:created_at).count
        budget_days.each do |created_at, count|
          next unless created_at == created_at.beginning_of_day || count > 1

          index = 1
          Account::Budget.where(stable:, created_at:).order(id: :asc).find_each do |budget|
            budget.assign_attributes(created_at: budget.created_at + index.seconds)
            budget.save(validate: false)
            index += 1
          end
        end
        step.advance! from: stable.id
      end
    end

    step :notify do |step|
      User::SendDeveloperNotifications.call(title: "Budget Update", message: "Timestamp transactions job finished")
    end
  end
end

