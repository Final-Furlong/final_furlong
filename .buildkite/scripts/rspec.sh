#!/bin/bash

# Making sure that script returns as soon as any command fails
set -euo pipefail

# Whether assets should be fetched
if [ "${ASSETS_PRECOMPILED}" == "true" ]; then
  echo "--- Download artifacts"
  buildkite-agent artifact download "*" . --step assets
fi

echo "--- Preparing database"
bundle exec rails db:reset

echo "--- Running rspec"
bundle exec rspec
