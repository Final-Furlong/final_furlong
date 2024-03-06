set :no_deploytags, true
set :branch, "staging"
set :stage, :staging
set :rails_env, :staging

set :deploy_to, "/var/www/staging.finalfurlong"

set :deploytag_time_format, "%Y.%m.%d-%H%M%S-utc"

append :linked_files, "config/credentials/staging.key", ".env.staging"

