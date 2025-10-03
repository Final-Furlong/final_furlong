class AuthenticatedPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    logged_in?
  end

  def show?
    logged_in?
  end

  def create?
    logged_in?
  end

  def new?
    create?
  end

  def update?
    logged_in?
  end

  def edit?
    update?
  end

  def destroy?
    logged_in?
  end

  private

  def logged_in?
    user.present?
  end
end

