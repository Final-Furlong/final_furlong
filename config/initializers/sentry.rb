Sentry.init do |config|
  config.dsn = "https://49bd65e43fd9495ba2c35e9d142cf5ed@o1325944.ingest.sentry.io/6585494"
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 0.25
end
