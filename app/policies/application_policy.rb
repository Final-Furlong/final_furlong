class ApplicationPolicy
  attr_reader :user, :record, :error_message_key, :error_message_18n_params

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private

  def admin?
    user&.admin?
  end

  def stable
    user&.stable
  end

  def logged_in?
    user.present?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
      @stable = user&.stable
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope, :stable
  end
end

