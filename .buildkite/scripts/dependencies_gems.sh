#!/bin/bash

# Making sure that script returns as soon as any command fails
set -euo pipefail

echo "--- Installing Gems"
bundle install
