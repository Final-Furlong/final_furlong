Rails.application.configure do
  config.lograge.enabled = if !Rails.env.development? || ENV.fetch("USE_LOGRAGE", "false") == "true"
    true
  else
    false
  end
end

