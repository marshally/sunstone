SunstoneCal::Application.configure do
  config.cache_classes = false

  config.consider_all_requests_local       = true

  config.action_controller.perform_caching = false

  config.action_mailer.raise_delivery_errors = false

  config.active_support.deprecation = :log

  config.action_dispatch.best_standards_support = :builtin

  config.assets.compress = false

  config.assets.debug = true

  config.cache_store = :dalli_store

end
