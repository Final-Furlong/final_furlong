source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "7.0.3.1"

gem "bootsnap", require: false

gem "devise", github: "ghiculescu/devise", branch: "error-code-422" # https://github.com/heartcombo/devise/pull/5340 not yet merged
gem "devise-i18n"
gem "responders"

gem "active_interaction"
gem "anycable-rails"
gem "anycable-rails-jwt", "~> 0.1.0"
gem "bootstrap"
gem "browser"
gem "callee"
gem "cssbundling-rails"
gem "dartsass-rails"
gem "data_migrate"
gem "discard"
gem "dotenv-rails"
gem "dotenv_validator"
gem "dry-validation"
gem "grape"
gem "grape-active_model_serializers"
gem "grape-entity"
gem "grape_on_rails_routes"
gem "haml"
gem "haml-rails"
gem "importmap-rails"
gem "motor-admin", "~> 0.3.4"
gem "mysql2"
gem "pagy"
gem "pg", "~> 1.1"
gem "pretender"
gem "puma", "~> 5.0"
gem "pundit"
gem "rack-cors"
gem "rails-i18n"
gem "redis", "~> 4.0"
gem "sentry-rails"
gem "sentry-ruby"
gem "sidekiq"
gem "sidekiq-cron"
gem "simple_form"
gem "stimulus-rails"
gem "strong_migrations"
gem "turbo-rails"
gem "turnout"
gem "view_component"
gem "whenever", require: false

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "rack-mini-profiler"

  gem "annotate", require: false
  gem "autoprefixer-rails"
  gem "bcrypt_pbkdf" # required for capistran
  gem "capistrano", "~> 3.17", require: false
  gem "capistrano-bundler", "~> 2.0", require: false
  gem "capistrano-deploytags", "~> 1.0.0", require: false
  gem "capistrano-passenger", require: false
  gem "capistrano-rails", "~> 1.3", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "capistrano-sidekiq", require: false
  gem "chusaku", require: false

  gem "ed25519", require: false # required for capistrano
  gem "guard", require: false
  gem "guard-bundler", require: false
  gem "guard-haml_lint", require: false
  gem "guard-rspec", require: false
  gem "guard-rubocop", require: false
  gem "terminal-notifier", require: false
  gem "terminal-notifier-guard", require: false
  gem "yalphabetize", require: false
end

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "brakeman"
  gem "bullet"
  gem "bundler-audit", require: false
  gem "byebug", platform: :mri
  gem "factory_bot-awesome_linter", require: false
  gem "factory_bot_rails", require: false
  gem "faker", require: false
  gem "fasterer", require: false
  gem "i18n-debug"
  gem "i18n-tasks"
  gem "letter_opener"
  gem "reek", require: false
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false
  gem "ruby-debug-ide", require: false
  gem "solargraph", require: false
end

group :test do
  gem "capybara", ">= 2.15"
  gem "capybara-screenshot"
  gem "fuubar"
  gem "i18n-spec"
  gem "rspec"
  gem "rspec_junit_formatter"
  gem "rspec-rails"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "simplecov-cobertura", require: false
  gem "simplecov-json", require: false
  gem "simplecov-lcov", require: false
  gem "undercover", require: false
  gem "webdrivers"
  gem "whenever-test"
end

