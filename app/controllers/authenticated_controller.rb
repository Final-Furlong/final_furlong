class AuthenticatedController < ApplicationController
  verify_authorized except: :index

  before_action :authenticate_user!, unless: :devise_controller?
  before_action :verify_active_user!, unless: :devise_controller?

  private

  def verify_active_user!
    redirect_to activation_path unless current_user.active?
  end
end

