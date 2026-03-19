# config valid for current version and patch releases of Capistrano
lock "~> 3.20.0"

server "ff", user: "www", roles: %i[web app db], primary: true

set :application, "final_furlong"
set :repo_url, "git@github.com:Final-Furlong/final_furlong.git"

set :branch, ENV.fetch("REVISION", "main")

set :rbenv_type, :user
set :rbenv_ruby, "3.4.5"

append :linked_files, "config/database.yml", ".rbenv-vars", ".nvmrc"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system",
  "vendor", "storage", ".bundle", "public/uploads", "public/vite"
append :assets_manifests, "public/vite/.vite/manifest*.*"

SSHKit.config.command_map[:npm] = "/home/www/.nvm/versions/node/v25.1.0/bin/npm"
SSHKit.config.command_map[:node] = "/home/www/.nvm/versions/node/v25.1.0/bin/node"
SSHKit.config.command_map[:pnpm] = "/home/www/.local/share/pnpm/pnpm"
set :npm_flags, "--prod --frozen-lockfile"
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

SSHKit.config.default_env = { path: "/home/www/.local/share/pnpm:/home/www/.nvm/versions/node/v25.1.0/bin:$PATH" }

before "deploy:migrate", "maintenance:start"
after "deploy:migrate", "maintenance:stop"
before "deploy:updated", "pnpm:install"

