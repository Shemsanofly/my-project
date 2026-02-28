require_relative "boot"
require_relative "../app/middleware/request_logger"

require "rails/all"

Bundler.require(*Rails.groups)

module GhalaRailsApi
  class Application < Rails::Application
    config.load_defaults 7.1
    config.api_only = true

    config.autoload_paths << Rails.root.join("app", "services")
    config.autoload_paths << Rails.root.join("app", "middleware")
    config.middleware.insert_before 0, RequestLogger
  end
end
