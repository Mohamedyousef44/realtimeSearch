#!/usr/bin/env bash

# Fail on error
set -o errexit

# Update packages and install MySQL client library (needed for mysql2 gem)
apt-get update -y
apt-get install -y libmysqlclient-dev

# Install Ruby gems
bundle install --jobs 4 --retry 3

# Compile assets (only if in production)
if [[ "$RAILS_ENV" == "production" ]]; then
  echo "Precompiling assets..."
  bundle exec rake assets:precompile
fi

# Run DB migrations (safe for dev or prod)
echo "Running database migrations..."
bundle exec rake db:migrate
