unless Rails.env.local?
  Sentry.init do |config|
    config.enabled_environments = %w[production]

    config.dsn = "https://20f25e73cb4cac4892de8a7725b0a223@o4510391246651392.ingest.de.sentry.io/4510402025029712"
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = 0.25

    config.rails.report_rescued_exceptions = false

    # Add data like request headers and IP for users,
    # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
    config.send_default_pii = true
  end
end

