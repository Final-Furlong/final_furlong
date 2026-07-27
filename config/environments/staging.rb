require_relative "production"

Rails.application.default_url_options = { host: "staging.finalfurlong.org" }

Rails.application.configure do
  config.active_support.report_deprecations = true
end

