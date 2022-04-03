# frozen_string_literal: true

# Load DSL and set up stages
require "capistrano/setup"
require "capistrano/deploy"

require "capistrano/rails"
require "capistrano/bundler"
require "capistrano/rbenv"
require "capistrano/passenger"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# require "capistrano/rails/assets"
# require "capistrano/rails/migrations"

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
