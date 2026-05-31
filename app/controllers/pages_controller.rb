class PagesController < ApplicationController
  skip_after_action :verify_pundit_authorization

  def home
  end

  def error
    _value = 1 / 0
    raise "There is a problem!"
  end
end

