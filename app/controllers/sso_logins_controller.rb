class SSOLoginsController < ApplicationController
  skip_after_action :verify_pundit_authorization, only: :show

  def show
    handler = Game::SSOHandler.new(return_url: sso_url)
    session[:sso_nonce] = handler.nonce

    redirect_to handler.sso_redirect_url, allow_other_host: true
  end
end

