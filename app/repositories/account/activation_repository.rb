module Account
  class ActivationRepository < ApplicationRepository
    def initialize(model: Account::Activation, scope: nil)
      @model = model
      super
    end

    def activated
      scope.where.not(activated_at: nil)
    end
  end
end

