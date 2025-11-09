source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: ".ruby-version"

gem "rails", "~> 8.1"

gem "solid_cable" # A database-backed ActionCable backend [https://github.com/rails/solid_cable]
gem "solid_cache" # A database-backed ActiveSupport::Cache::Store [https://github.com/rails/solid_cache]
gem "solid_queue" # A database-backed ActiveJob backend [https://github.com/rails/solid_queue]

# Backend
gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb
gem "puma" # Use the Puma web server [https://github.com/puma/puma]

# Asset management
gem "fastimage"
gem "image_processing" # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "jbuilder" # Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "propshaft" # Deliver assets for Rails [https://github.com/rails/propshaft]
gem "stimulus-rails" # Hotwire"s modest JavaScript framework [https://stimulus.hotwired.dev]
gem "turbo-rails" # Hotwire"s SPA-like page accelerator [https://turbo.hotwired.dev]

# Authentication/Authorization
gem "devise"
gem "devise-i18n"
gem "pundit"

# Operations
gem "active_interaction"
gem "dry-validation"
gem "yaaf"

# Utilities
gem "base64", "0.1.1"
gem "browser"
gem "dotenv-rails"
gem "dotenv_validator"
gem "lograge"
gem "mailtrap"
gem "mission_control-jobs"
gem "net-ssh"
gem "rack-cors"
gem "rails-i18n"
gem "ransack"
gem "requestjs-rails"
gem "responders"
gem "sentry-rails"
gem "sentry-ruby"
gem "turnout"
gem "web-push"
gem "whenever", require: false

# API
gem "grape"
gem "grape-active_model_serializers"
gem "grape-entity"
gem "grape_logging"
gem "grape_on_rails_routes"

# Admin
gem "motor-admin"
gem "pretender"

# UI
gem "pagy"
gem "simple_form"
gem "slim-rails"
gem "tailwindcss-rails"
gem "view_component"
gem "view_component-contrib"
gem "vite_rails"

# Database
gem "activerecord_json_validator"
gem "active_storage_validations"
gem "counter_culture"
gem "data_migrate"
gem "discard"
gem "flag_shih_tzu" # bit mask
gem "friendly_id"
gem "mysql2"
gem "nanoid"
gem "pg" # Use postgresql as the database for Active Record
gem "pghero"
gem "pg_query", ">= 2"
gem "rails-pg-extras"
gem "scenic" # versioned views
gem "store_model"
gem "strong_migrations"

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
  gem "bullet"
  gem "byebug"
  gem "capistrano", "~> 3.17", require: false
  gem "capistrano-bundler", "~> 2.0", require: false
  gem "capistrano-deploytags", "~> 1.0.0", require: false
  gem "capistrano-passenger", require: false
  gem "capistrano-rails", "~> 1.3", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "capistrano-solid_queue", require: false
  gem "capistrano-yarn", require: false
  gem "ed25519", require: false # required for capistrano
  gem "good_migrations"
  gem "guard", require: false
  gem "guard-bundler", require: false
  gem "guard-haml_lint", require: false
  gem "guard-rspec", require: false
  gem "guard-rubocop", require: false
  gem "i18n-debug"
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
  gem "bundler-audit", require: false
  gem "debug"
  gem "factory_bot-awesome_linter", require: false
  gem "factory_bot_rails", require: false
  gem "faker", require: false
  gem "fasterer", require: false
  gem "i18n-tasks"
  gem "isolator"
  gem "letter_opener"
  gem "puts_debuggerer"
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
  gem "simplecov-tailwindcss", require: false
  gem "undercover", require: false
  gem "whenever-test"
end

group :tools do
  gem "colorize", require: false
end

