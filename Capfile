# Load DSL and set up stages
require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/pnpm"

require "capistrano/rails"
require "capistrano/bundler"
require "capistrano/rbenv"
require "capistrano/passenger"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# require "capistrano/rails/assets"
# require "capistrano/rails/migrations"

require "capistrano/deploytags"
require "capistrano/data_migrate"

require "capistrano/solid_queue"
install_plugin Capistrano::SolidQueue::Systemd

require "whenever/capistrano"

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

