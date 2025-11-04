class UpdateBudgetBalancesService
  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    Account::Stable.find_each do |stable|
      balance = 0
      Account::Budget.where(stable:).order(created_at: :asc).find_each do |budget|
        balance += budget.amount
        budget.assign_attributes(balance:)
        budget.save(validate: false)
      end
      stable.update(total_balance: balance)
      print "." # rubocop:disable Rails/Output
    end
    ActiveRecord::Base.logger = old_logger
    nil
  rescue => e
    Rails.logger.error "Info: #{e.message}"
    raise e
  end
end

