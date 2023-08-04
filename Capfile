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

require "capistrano/deploytags"
# require "capistrano/data_migrate"

# # # require "capistrano/sidekiq"
# # install_plugin Capistrano::Sidekiq
# install_plugin Capistrano::Sidekiq::Systemd

require "whenever/capistrano"

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

