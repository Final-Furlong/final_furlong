#!/bin/bash

# Making sure that script returns as soon as any command fails
set -euo pipefail

echo "--- Assets - Precompile"
bundle exec rails assets:precompile

echo "--- Assets - Upload"
buildkite-agent artifact upload "public/**/*"
