module T
  include Dry::Types(default: :strict)
end

class BaseOperation
  include Dry::Monads[:result]
  include Dry::Monads::Do.for(:call)
  include Pundit::Authorization

  attr_reader :current_user

  def initialize(user:)
    @current_user = user
  end
end

