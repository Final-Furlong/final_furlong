module Game
  class SSOHandler
    attr_reader :return_url, :nonce, :base64_payload, :sso_url_encoded, :sig_hex_encoded

    def initialize(return_url: nil)
      @return_url = return_url
    end

    def nonce
      @nonce ||= SecureRandom.hex
    end

    def sso_url_encoded
      return @url_encoded if defined?(@url_encoded)

      payload = "nonce=#{nonce}&return_sso_url=#{return_url}"
      @base64_payload = encode_value(payload)
      @url_encoded = CGI.escape(base64_payload)
    end

    def sig_hex_encoded
      @hex_signature ||= hex_digest(base64_payload)
    end

    def sso_redirect_url
      [
        Rails.application.credentials.dig(:forum, :url),
        Rails.application.credentials.dig(:forum, :sso_session_path).gsub(":sso", sso_url_encoded).gsub(":sig", sig_hex_encoded)
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
