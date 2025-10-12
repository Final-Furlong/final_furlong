# config valid for current version and patch releases of Capistrano
lock "~> 3.19.0"

server "ffdeploy", user: "www", roles: %i[web app db], primary: true

set :application, "final_furlong"
set :repo_url, "git@github.com:Final-Furlong/final_furlong.git"

set :branch, ENV.fetch("REVISION", "main")

set :rbenv_type, :user
set :rbenv_ruby, "3.4.5"

append :linked_files, "config/database.yml", ".rbenv-vars"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system",
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

set :yarn_flags, "--production --pure-lockfile --no-emoji --no-progress --ignore-engines"

# solid queue
set :solid_queue_systemd_unit_name, "solid-queue-ff.service"

namespace :solid_queue do
  desc "Quiet solid_queue (start graceful termination)"
  task :quiet do
    on roles(:app) do
      execute :systemctl, "--user", "kill", "-s", "SIGTERM", fetch(:solid_queue_systemd_unit_name), raise_on_non_zero_exit: false
    end
  end

  desc "Stop solid_queue (force immediate termination)"
  task :stop do
    on roles(:app) do
      execute :systemctl, "--user", "kill", "-s", "SIGQUIT", fetch(:solid_queue_systemd_unit_name), raise_on_non_zero_exit: false
    end
  end

  desc "Start solid_queue"
  task :start do
    on roles(:app) do
      execute :systemctl, "--user", "start", fetch(:solid_queue_systemd_unit_name)
    end
  end

  desc "Restart solid_queue"
  task :restart do
    on roles(:app) do
      execute :systemctl, "--user", "restart", fetch(:solid_queue_systemd_unit_name)
    end
  end
end

after "deploy:starting", "solid_queue:quiet"
after "deploy:updated", "solid_queue:stop"
after "deploy:published", "solid_queue:start"
after "deploy:failed", "solid_queue:restart"

before "deploy:migrate", "maintenance:start"
after "deploy:migrate", "maintenance:stop"

