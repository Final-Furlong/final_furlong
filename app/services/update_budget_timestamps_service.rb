class UpdateBudgetTimestampsService
  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    Account::Stable.find_each do |stable|
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
      print "." # rubocop:disable Rails/Output
    end
    ActiveRecord::Base.logger = old_logger
    nil
  rescue => e
    Rails.logger.error "Info: #{e.message}"
    raise e
  end
end

