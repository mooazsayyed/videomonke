# syntax = docker/dockerfile:1

# Stage 1: Build
ARG RUBY_VERSION=3.3.1
FROM ruby:$RUBY_VERSION-slim AS build

# Set working directory
WORKDIR /rails

# Install dependencies for building gems
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential git libvips pkg-config

# Install bundler
RUN gem install bundler

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy application files and precompile assets
COPY . .
RUN SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile

# Stage 2: Runtime
FROM ruby:$RUBY_VERSION-slim AS runtime

# Set working directory
WORKDIR /rails

# Set production environment variables
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Copy built application from the build stage
COPY --from=build /rails /rails

# Expose port 3000
EXPOSE 3000

# Start Rails server
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
