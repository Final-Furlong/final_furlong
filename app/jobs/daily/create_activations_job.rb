class Daily::CreateActivationsJob < ApplicationJob
  queue_as :low_priority

  def perform
    created_activations = 0
    Account::User.where.missing(:activation).active.find_each do |user|
      CreateActivationService.new(user.id).call
      created_activations += 1
    end
    store_job_info(outcome: { activations: created_activations })
  end
end

