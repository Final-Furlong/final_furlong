source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.5"

gem "rails", "~> 8.0"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire"s SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire"s modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

gem "devise"
gem "devise-i18n"
gem "responders"

gem "action_policy"
gem "active_interaction"
gem "activerecord_json_validator"
gem "active_storage_validations"
gem "base64", "0.1.1"
gem "browser"
gem "counter_culture"
gem "data_migrate"
gem "discard"
gem "dotenv-rails"
gem "dotenv_validator"
gem "dry-validation"
gem "fastimage"
gem "grape"
gem "grape-active_model_serializers"
gem "grape-entity"
gem "grape_on_rails_routes"
gem "image_processing"
gem "lograge"
gem "mailtrap"
gem "mission_control-jobs"
gem "motor-admin"
gem "mysql2"
gem "net-ssh"
gem "pagy"
gem "pghero"
gem "pg_query", ">= 2"
gem "pretender"
gem "pundit"
gem "rack-cors"
gem "rails-i18n"
gem "rails-pg-extras"
gem "ransack"
gem "redis"
gem "sentry-rails"
gem "sentry-ruby"
gem "simple_form"
gem "slim-rails"
gem "solid_queue"
gem "store_model"
gem "strong_migrations"
gem "tailwindcss-rails"
gem "turnout"
gem "uuid"
gem "view_component"
gem "view_component-contrib"
gem "whenever", require: false
gem "yaaf"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "rack-mini-profiler"

  gem "annotaterb", require: false
  gem "autoprefixer-rails"
  gem "bcrypt_pbkdf" # required for capistran
  gem "benchmark"
  gem "better_errors"
  gem "byebug"
  gem "capistrano", "~> 3.17", require: false
  gem "capistrano-bundler", "~> 2.0", require: false
  gem "capistrano-deploytags", "~> 1.0.0", require: false
  gem "capistrano-passenger", require: false
  gem "capistrano-rails", "~> 1.3", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "capistrano-yarn", require: false
  gem "ed25519", require: false # required for capistrano
  gem "good_migrations"
  gem "guard", require: false
  gem "guard-bundler", require: false
  gem "guard-haml_lint", require: false
  gem "guard-rspec", require: false
  gem "guard-rubocop", require: false
  gem "image_optim", require: false
  gem "image_optim_pack", require: false
  gem "image_optim_rails", require: false
  gem "terminal-notifier", require: false
  gem "terminal-notifier-guard", require: false
  gem "yalphabetize", require: false
end

group :development, :test do
  gem "active_record_doctor"
  gem "binding_of_caller"
  gem "brakeman", require: false
  gem "bullet"
  gem "bundler-audit", require: false
  gem "debug"
  gem "factory_bot-awesome_linter", require: false
  gem "factory_bot_rails", require: false
  gem "faker", require: false
  gem "fasterer", require: false
  gem "i18n-debug"
  gem "i18n-tasks"
  gem "isolator"
  gem "letter_opener"
  gem "puts_debuggerer", "~> 1.0.0"
  gem "reek", require: false
  gem "rubocop", require: false
  gem "rubocop-capybara", require: false
  gem "rubocop-factory_bot", require: false
  gem "rubocop-graphql", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rspec_rails", require: false
  gem "ruby-debug-ide", require: false
  gem "slim_lint", require: false
  gem "solargraph", require: false
  gem "standard"
  gem "standard-performance"
  gem "standard-rails"
end

group :test do
  gem "axe-core-capybara"
  gem "axe-core-rspec"
  gem "capybara", ">= 2.15"
  gem "capybara-screenshot"
  gem "cuprite"
  gem "fuubar"
  gem "i18n-spec"
  gem "pundit-matchers"
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
  gem "whenever-test"
end

group :tools do
  gem "colorize", require: false
end

