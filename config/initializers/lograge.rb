Rails.application.configure do
  config.lograge.enabled = ENV.fetch("USE_LOGRAGE", "false") == "true"
end

