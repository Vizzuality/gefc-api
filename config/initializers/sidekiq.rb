Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1') }
  config.redis = {size: (config.options[:concurrency] + 5), network_timeout: 5}
end
Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1') }
  config.redis = {size: config.options[:concurrency], network_timeout: 5}
end