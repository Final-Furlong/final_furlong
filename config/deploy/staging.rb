server "ff2", user: "www", roles: %i[web app db], primary: true

set :no_deploytags, true
set :branch, "main"
set :stage, :staging
set :rails_env, :staging

set :deploy_to, "/var/www/staging.finalfurlong"

append :linked_files, "config/credentials/staging.key", ".env.staging"

