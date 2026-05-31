unless Rails.env.local?
  Sentry.init do |config|
    config.enabled_environments = %w[production]

    config.dsn = Rails.application.credentials.sentry_dsn
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = 0.25

    config.rails.report_rescued_exceptions = true

    config.enable_logs = true
    # Patch Ruby logger to forward logs
    config.enabled_patches = [:logger]

    # Add data like request headers and IP for users,
    # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
    config.send_default_pii = true
  end
end

