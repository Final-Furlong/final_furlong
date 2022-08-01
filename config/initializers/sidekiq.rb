Sidekiq.configure_server do |config|
  config.redis = if Rails.env.development?
                   { url: ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379/0") }
                 else
                   { url: ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379/0"), password: ENV.fetch("REDIS_PASSWORD", "") }
                 end
end

Sidekiq.configure_client do |config|
  config.redis = if Rails.env.development?
                   { url: ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379/0") }
                 else
                   { url: ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379/0"), password: ENV.fetch("REDIS_PASSWORD", "") }
                 end
end
