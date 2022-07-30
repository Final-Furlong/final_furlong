I18n::Debug.logger = Logger.new(Rails.root.join("log/i18n.log")) if Rails.env.development? && defined? I18n::Debug
