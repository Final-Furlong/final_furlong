class PagesController < ApplicationController
  skip_after_action :verify_pundit_authorization

  def home
  end
end

