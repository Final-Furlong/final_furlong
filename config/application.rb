require_relative "boot"

ENV["RANSACK_FORM_BUILDER"] = "::SimpleForm::FormBuilder"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.require "view_component/engine"

Bundler.require(*Rails.groups)

module FinalFurlong
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators do |g|
      g.test_framework :rspec
    end

    config.log_formatter = Logger::Formatter.new
    config.exceptions_app = routes
    config.i18n.available_locales = [:en, "en-GB"]
    config.i18n.default_locale = :en
    config.i18n.fallbacks = { "en-GB" => :en }

    if ENV["RAILS_LOG_TO_STDOUT"].present?
      logger = ActiveSupport::Logger.new($stdout)
      logger.formatter = config.log_formatter
      config.logger = ActiveSupport::TaggedLogging.new(logger)
    end

    # API
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "*"
        resource "*", headers: :any, methods: %i[get post put delete options]
      end
    end
  end
end

Turnout.configure do |config|
  config.app_root = "."
  config.named_maintenance_file_paths = { default: config.app_root.join("tmp", "maintenance.yml").to_s }
  config.maintenance_pages_path = config.app_root.join("public").to_s
  config.default_maintenance_page = Turnout::MaintenancePage::HTML
  config.default_reason = "The site is temporarily down for maintenance.\nPlease check back soon."
  config.default_allowed_paths = ["grooming-horse.png"]
  config.default_response_code = 503
  config.default_retry_after = 7200
end

