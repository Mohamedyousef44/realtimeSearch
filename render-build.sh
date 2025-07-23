# Ensure packages are up to date and install libmysqlclient-dev for mysql2 gem
apt-get update && apt-get install -y libmysqlclient-dev

# Install Ruby dependencies
bundle install

# Precompile assets for production
bundle exec rake assets:precompile

# Run migrations
bundle exec rake db:migrate