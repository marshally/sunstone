SunstoneCal::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = false
  config.assets.compress = true
  config.assets.compile = false
  config.assets.digest = true

  if ENV["MEMCACHIER_SERVERS"]
    require 'dalli'
    config.cache_store = :dalli_store,
      (ENV["MEMCACHIER_SERVERS"] || "").split(","),
      {
        username: ENV["MEMCACHIER_USERNAME"],
        password: ENV["MEMCACHIER_PASSWORD"],
        failover: true,
        socket_timeout: 1.5,
        socket_failure_delay: 0.2
      }
  end

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
end
