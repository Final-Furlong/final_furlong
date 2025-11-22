class Daily::CreateActivationsJob < ApplicationJob
  queue_as :low_priority

  def perform
    Account::User.where.missing(:activation).active.find_each do |user|
      CreateActivationService.new(user.id).call
    end
  end
end

