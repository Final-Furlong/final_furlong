module Account
  class UsersRepository < ApplicationRepository
    def initialize(model: User, scope: nil)
      @model = model
      super
    end

    delegate :active, to: :model

    def ordered
      scope.order(id: :desc)
    end
  end
end

