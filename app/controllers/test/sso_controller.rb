module Test
  class SSOController < ApplicationController
    skip_after_action :verify_pundit_authorization, only: :show

    def show
      user_hash = {
        admin: "true",
        avatar_url: "https://example.com/uploads/default/avatar.jpeg",
        email: "admin@example.com",
        external_id: "1",
        groups: "trust_level_0,trust_level_1,trust_level_2,trust_level_3",
        moderator: "false",
        nonce: session[:nonce],
        return_sso_url: sso_path,
        username: "admin"
      }
      handler = Game::SSOHandler.new
      user_string = handler.encode_value(user_hash.to_query)
      redirect_to sso_path(sso: user_string, sig: handler.hex_digest(user_string))
    end
  end
end

