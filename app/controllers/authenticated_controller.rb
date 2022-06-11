# typed: false
class AuthenticatedController < ApplicationController
  before_action :authenticate_user!, unless: :devise_controller?
end
