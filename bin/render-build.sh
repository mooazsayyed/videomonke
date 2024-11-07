#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# If you want to run database migrations on Render during build
bundle exec rails db:migrate RAILS_ENV=production
