# config valid for current version and patch releases of Capistrano
lock "~> 3.17.0"

server "ffdeploy", user: "www", roles: %i[web app db], primary: true

set :application, "final_furlong"
set :repo_url, "git@github.com:pendletons/final_furlong.git"

set :branch, ENV.fetch("REVISION", "main")

set :rbenv_type, :user
set :rbenv_ruby, "3.1.2"

set :deploy_to, "/var/www/rails.finalfurlong"

append :linked_files, "config/database.yml", ".rbenv-vars", "config/initializers/sidekiq.rb"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", \
       "vendor", "storage", ".bundle", "public/uploads"

set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

after "deploy", "deploy:cleanup"

set :keep_releases, 3

set :passenger_restart_with_touch, true

set :ssh_options, {
  keys: %w[~/.ssh/ff_capistrano],
  forward_agent: true,
  auth_methods: %w[publickey],
  verify_host_key: :always
}

before "deploy:migrate", "maintenance:start"
after "deploy:migrate", "maintenance:end"
