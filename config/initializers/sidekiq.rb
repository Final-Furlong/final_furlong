Sidekiq.configure_server do |config|
  config.redis = { url: "redis://redis.example.com:7372/0", password: ENV.fetch("REDIS_PASSWORD", "") }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://redis.example.com:7372/0", password: ENV.fetch("REDIS_PASSWORD", "") }
end
