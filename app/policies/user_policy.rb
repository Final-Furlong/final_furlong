# typed: strict

class CreateParams < T::Struct
  prop :username, T.nilable(String)
  prop :name, T.nilable(String)
  prop :email, T.nilable(String)
  prop :password, T.nilable(String)
  prop :password_confirmation, T.nilable(String)
end

class UpdateParams < T::Struct
  prop :name, T.nilable(String)
  prop :email, T.nilable(String)
  prop :password, T.nilable(String)
  prop :password_confirmation, T.nilable(String)
end

class UserPolicy < ApplicationPolicy
  extend T::Sig

  sig { params(params: ActionController::Parameters).returns(T::Hash[String, T.nilable(String)]) }
  def permitted_attributes_for_create(params)
    TypedParams[CreateParams].new.extract!(params).serialize
  end

  sig { params(params: ActionController::Parameters).returns(T::Hash[String, T.nilable(String)]) }
  def permitted_attributes_for_edit(params)
    TypedParams[UpdateParams].new.extract!(params).serialize
  end
end
