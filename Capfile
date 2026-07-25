# Load DSL and set up stages
require "capistrano/setup"
require "capistrano/deploy"
# require "capistrano/pnpm"

require "capistrano/rails"
require "capistrano/bundler"
require "capistrano/rbenv"
require "capistrano/puma"
install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Systemd

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# require "capistrano/rails/assets"
# require "capistrano/rails/migrations"

require "capistrano/deploytags"
require "capistrano/data_migrate"

require "whenever/capistrano"

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

