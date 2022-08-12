class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    user&.admin?
  end

  def show?
    user&.admin?
  end

  def new?
    user&.admin?
  end

  def create?
    new?
  end

  def edit?
    user&.admin?
  end

  def update?
    edit?
  end

  def destroy?
    user&.admin?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

      attr_reader :user, :scope
  end
end

