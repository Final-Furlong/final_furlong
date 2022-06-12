source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.1"

gem "rails", "7.0.2.3"

gem "bootsnap", require: false

gem "devise", github: "ghiculescu/devise", branch: "error-code-422" # https://github.com/heartcombo/devise/pull/5340 not yet merged
gem "devise-i18n"
gem "responders", github: "heartcombo/responders" # https://github.com/heartcombo/responders/pull/223 not yet released

gem "bulma-rails"
gem "danger"
gem "danger-missed_localizable_strings"
gem "danger-rails_best_practices"
gem "danger-simplecov_json"
gem "dartsass-rails"
gem "dotenv_validator"
gem "friendly_id"
gem "gretel"
gem "haml"
gem "haml-rails"
gem "jbuilder"
gem "jsbundling-rails"
gem "pagy"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rails_admin"
gem "redis", "~> 4.0"
gem "simple_form"
gem "sorbet-rails"
gem "sorbet-runtime"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "view_component"

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

  gem "annotate"
  gem "bcrypt_pbkdf" # required for capistran
  gem "capistrano", "~> 3.17", require: false
  gem "capistrano-bundler", "~> 2.0", require: false
  gem "capistrano-passenger", require: false
  gem "capistrano-rails", "~> 1.3", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "chusaku", require: false
  gem "hotwire-livereload"
  gem "pry"
  gem "sorbet", require: false
  gem "sorbet-progress", require: false
  gem "tapioca"
  gem "yalphabetize", require: false
end

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "brakeman"
  gem "bullet"
  gem "bundler-audit"
  gem "byebug", platform: :mri
  gem "debase", github: "ruby-debug/debase", tag: "v0.2.5.beta2", require: false
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails"
  gem "ed25519" # required for capistrano
  gem "factory_bot-awesome_linter"
  gem "factory_bot_rails"
  gem "faker", require: false
  gem "i18n-tasks"
  gem "letter_opener"
  gem "overcommit"
  gem "pry-rescue"
  gem "pry-stack_explorer"
  gem "reek"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rake", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-sorbet", require: false
  gem "ruby-debug-ide", require: false
  gem "solargraph", require: false
  gem "unparser", require: false # required for rubocop-sorbet
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
  gem "simplecov-json", require: false
  gem "simplecov-lcov", require: false
  gem "undercover", require: false
  gem "webdrivers"
end
