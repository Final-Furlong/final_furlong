class ApplicationPolicy < ActionPolicy::Base
  attr_reader :user, :record

  def initialize(target, user:)
    @user = user
    @record = target
  end

  def index?
    false
  end

  def show?
    false
  end

  def new?
    false
  end

  def create?
    new?
  end

  def edit?
    false
  end

  def update?
    edit?
  end

  def destroy?
    false
  end
end

