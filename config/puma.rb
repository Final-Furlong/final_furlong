# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.
#
# Puma starts a configurable number of processes (workers) and each process
# serves each request in a thread from an internal thread pool.
#
# You can control the number of workers using ENV["WEB_CONCURRENCY"]. You
# should only set this value when you want to run 2 or more workers. The
# default is already 1. You can set it to `auto` to automatically start a worker
# for each available processor.
#
# The ideal number of threads per worker depends both on how much time the
# application spends waiting for IO operations and on how much you wish to
# prioritize throughput over latency.
#
# As a rule of thumb, increasing the number of threads will increase how much
# traffic a given process can handle (throughput), but due to CRuby's
# Global VM Lock (GVL) it has diminishing returns and will degrade the
# response time (latency) of the application.
#
# The default is set to 3 threads as it's deemed a decent compromise between
# throughput and latency for the average Rails application.
#
# Any libraries that use a connection pool or another resource pool should
# be configured to provide at least as many connections as the number of
# threads. This includes Active Record's `pool` parameter in `database.yml`.
#

if %w[production staging].include?(ENV.fetch("RAILS_ENV", "development"))
  app_dir = File.expand_path("../../..", __FILE__)
  shared_dir = "#{app_dir}/shared"

  # Run from the current symlink so phased restarts load the active release
  directory "#{app_dir}/current"

  # Number of Puma workers (processes)
  # Adjust based on RAM: each worker uses ~300-500MB
  workers ENV.fetch("WEB_CONCURRENCY", 3).to_i

  # PID file location
  pidfile "#{shared_dir}/tmp/pids/puma.pid"

  # State file (used for phased restart)
  state_path "#{shared_dir}/tmp/pids/puma.state"

  # Use Unix socket for Nginx communication (faster than TCP)
  bind "unix://#{shared_dir}/tmp/sockets/puma.sock"

  # Activate Puma's control server for zero-downtime deploys
  activate_control_app

  # Log locations
  stdout_redirect "#{shared_dir}/log/puma.stdout.log",
    "#{shared_dir}/log/puma.stderr.log",
    true

  # Allow phased restarts to load code and gems from the active release
  prune_bundler
else
  port ENV.fetch("PORT", 3000)
end

# Number of threads per worker
# Adjust based on application concurrency characteristics
threads_count = ENV.fetch("RAILS_MAX_THREADS", 5).to_i
threads threads_count, threads_count

# Environment
environment ENV.fetch("RAILS_ENV", "production")

# Properly handle database connection after forking
before_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

# GoodJob setup
if ENV.fetch("WEB_CONCURRENCY", 3).to_i > 0
  before_fork do
    GoodJob.shutdown
  end

  before_worker_boot do
    GoodJob.restart
  end

  before_worker_shutdown do
    GoodJob.shutdown
  end
end

MAIN_PID = Process.pid
at_exit do
  GoodJob.shutdown if Process.pid == MAIN_PID
end

# Specify the PID file. Defaults to tmp/pids/server.pid in development.
# In other environments, only set the PID file if requested.
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Allow Puma to be restarted by `rails restart` command
plugin :tmp_restart

