if defined? I18n::Debug
  I18n::Debug.logger = Logger.new(Rails.root.join("log/i18n.log")) if Rails.env.development?
end

module I18n
  module Tasks
    module MissingKeys
      def locale_key_missing?(locale, key)
        # use fallbacks
        !I18n.exists?(key, locale) && !external_key?(key, locale) && !ignore_key?(key, :missing)
      end
    end
  end
end

