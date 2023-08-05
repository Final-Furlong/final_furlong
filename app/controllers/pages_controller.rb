class PagesController < ApplicationController
  skip_after_action :verify_authorized

  # @route GET / (root)
  def home
  end

  # @route GET /activation_required (activation)
  def activation
  end
end
