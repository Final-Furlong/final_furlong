class SSOLoginsController < ApplicationController
  skip_after_action :verify_pundit_authorization, only: :show

  def show
    # nonce = "cb68251eefb5211e58c00ff1395f0c0b"
    # pd nonce
    # payload = "nonce=#{nonce}"
    # pd payload
    # base64 = Base64.encode64(payload).strip
    # pd base64 # bm9uY2U9Y2I2ODI1MWVlZmI1MjExZTU4YzAwZmYxMzk1ZjBjMGI=
    # url_encoded = CGI.escape(base64) # bm9uY2U9Y2I2ODI1MWVlZmI1MjExZTU4YzAwZmYxMzk1ZjBjMGI%3D
    # pd url_encoded
    # hex_signature = OpenSSL::HMAC.hexdigest("SHA256", "d836444a9e4084d5b224a60c208dce14", url_encoded).downcase
    # pd hex_signature
    # 1ce1494f94484b6f6a092be9b15ccc1cdafb1f8460a3838fbb0e0883c4390471
    #
    # web    |   => "c98ded83307f60295a4ec4f96d5ca96290eb2b393eed60f008918e0d621f2e09"
    #

    nonce = SecureRandom.hex
    session[:sso_nonce] = nonce

    payload = "nonce=#{nonce}&return_sso_url=http://localhost:3000/sso"
    pd payload
    base64_payload = Base64.encode64(payload)
    pd base64_payload
    url_encoded = CGI.escape(base64_payload)
    pd url_encoded
    hex_signature = OpenSSL::HMAC.hexdigest("SHA256", Rails.application.credentials.dig(:discourse_sso_key), base64_payload).downcase
    pd Rails.application.credentials.dig(:discourse_sso_key)
    pd hex_signature

    redirect_to "#{Rails.application.credentials.dig(:forum_url)}session/sso_provider?sso=#{url_encoded}&sig=#{hex_signature}", allow_other_host: true
  end
end

