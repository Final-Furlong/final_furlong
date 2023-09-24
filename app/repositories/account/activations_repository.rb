module Account
  class ActivationsRepository < ApplicationRepository
    def activate!(activation)
      ActiveRecord::Base.transaction do
        activation.user.active!
        activation.update!(activated_at: Time.current)
      end
    end
  end
end

