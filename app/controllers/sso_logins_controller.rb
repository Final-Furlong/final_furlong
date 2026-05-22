class SSOLoginsController < ApplicationController
  skip_after_action :verify_pundit_authorization, only: :show

  def show
    pd "do login stuff"
    handler = Game::SSOHandler.new(return_url: sso_url)
    session[:sso_nonce] = handler.nonce
    pd session[:sso_nonce]

    pd handler.sso_redirect_url
    redirect_to handler.sso_redirect_url, allow_other_host: true
  end
end

