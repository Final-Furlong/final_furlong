# typed: true
class ApplicationController < ActionController::Base
  extend T::Sig
  include Pagy::Backend

  protect_from_forgery prepend: true
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  protected

  sig { returns(Symbol) }
  def set_locale
    # TODO: set this per user
    I18n.locale = :en
  end

  sig { returns(T::Types::Untyped) }
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: sign_up_keys)
    devise_parameter_sanitizer.permit(:sign_in, keys: sign_in_keys)
    devise_parameter_sanitizer.permit(:account_update, keys: account_update_keys)
  end

  sig { returns(T::Array[Symbol]) }
  def sign_in_keys
    %i[login password password_confirmation]
  end

  sig { returns(T::Array[Symbol]) }
  def account_update_keys
    %i[username name email password_confirmation current_password]
  end

  sig { returns(T::Array[T.any(T::Hash[T.untyped, T.untyped], Symbol)]) }
  def sign_up_keys
    [:username, :email, :name, :password, :password_confirmation, { stable_attributes: [:name] }]
  end
end
