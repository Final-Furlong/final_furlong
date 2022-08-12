class UsersRepository < ApplicationRepository
  def initialize(model: User, scope: nil)
    @model = model
    super
  end

  delegate :active, to: :model
end

