class PagesController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  # @route GET / (root)
  def home
  end

  # @route GET /activation_required (activation)
  def activation
  end
end

