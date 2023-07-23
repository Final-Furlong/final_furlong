module Users
  class GenerateToken < BaseInteraction
    object :user, class: Account::User, default: nil
    object :cookies, class: ActionDispatch::Cookies::CookieJar

    string :locale, default: I18n.default_locale.to_s

    def execute
      JWT.encode(payload, hmac_secret, hmac_algorithm)
    end

    private

      def payload
        {
          sub: user.id,
          jti: jwt_id,
          iat: issued_at,
          exp: expiration_time
        }
      end

      def jwt_id
        jti_raw = [hmac_secret, issued_at].join(":").to_s
        Digest::MD5.hexdigest(jti_raw)
      end

      def issued_at
        Time.current
      end

      def expiration_time
        1.day.from_now
      end

      def hmac_secret
        Rails.application.secrets.secret_key_base
      end

      def hmac_algorithm
        ENV.fetch("HMAC_ALGORITHM", nil)
      end
  end
end

