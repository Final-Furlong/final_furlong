server "ff2", user: "www", roles: %i[web app db], primary: true

set :branch, "production"
set :stage, :production
set :rails_env, :production

set :deploy_to, "/var/www/prod.finalfurlong"

set :deploytag_time_format, "%Y.%m.%d-%H%M%S-utc"

append :linked_files, "config/credentials/production.key", ".env.production"

