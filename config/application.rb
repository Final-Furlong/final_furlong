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
# you've limited to :test, :development, or :production.

Bundler.require(*Rails.groups)

module FinalFurlong
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_record.default_timezone = :local

    config.mission_control.jobs.http_basic_auth_enabled = false

    config.active_record.schema_format = :sql

    # Don't generate system test files.
    config.generators do |g|
      g.system_tests = nil
      g.test_framework :rspec
      g.template_engine = :slim
      g.helper false
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

