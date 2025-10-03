class PagesController < ApplicationController
  def home
    skip_authorization
  end

  def activation
  end
end

