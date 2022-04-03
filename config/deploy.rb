# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock "~> 3.17.0"

server "ff", user: "www", roles: %i[web app db], primary: true

set :application, "final_furlong"
set :repo_url, "git@github.com:pendletons/final_furlong.git"

set :branch, ENV.fetch("REVISION", "main")

set :deploy_to, "/var/www/rails.finalfurlong"

append :linked_files, "config/database.yml", ".rbenv-vars"
append :linked_dirs, "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage",
       ".bundle"

set :keep_releases, 3

set :ssh_options, {
  keys: %w[~/.ssh/ff_deploy],
  forward_agent: true,
  auth_methods: %w[publickey],
  verify_host_key: :always
}
