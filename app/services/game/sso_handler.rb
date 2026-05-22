# frozen_string_literal: true

module Game
  class SSOHandler
    attr_reader :nonce

    def initialize(return_url: nil)
      @return_url = return_url
      @nonce = SecureRandom.alphanumeric(20)
    end

    def sso_url_encoded
      @payload = "nonce=#{@nonce}&return_sso_url=#{@return_url}"
      CGI.escape(encode_value(@payload))
    end

    def sig_hex_encoded
      hex_digest(encode_value(@payload))
    end

    def sso_redirect_url
      session_url = Rails.application.credentials.dig(:forum, :sso_session_path).dup
      session_url.sub!(":sso", sso_url_encoded)
      session_url.sub!(":sig", sig_hex_encoded)
      [
        Rails.application.credentials.dig(:forum, :url),
        session_url
      ].join("")
    end

    def hex_digest(value)
      OpenSSL::HMAC.hexdigest("SHA256", Rails.application.credentials.dig(:forum, :sso_key), value).downcase
    end

    def base64?(data)
      !(data =~ /[^a-zA-Z0-9=\r\n\/+]/m)
    end

    def encode_value(value)
      Base64.encode64(value)
    end

    def decoded_hash(value)
      hash = Rack::Utils.parse_query(Base64.decode64(value))
      hash.symbolize_keys!
    end
  end
end

