# Use the official Ruby image
FROM ruby:3.3.1

# Set the working directory in the container
WORKDIR /usr/src/app

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    sqlite3

# Set up bundler
RUN gem install bundler

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application files
COPY . .

# Precompile assets for production
RUN SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile

# Expose port 3000 to the outside world
EXPOSE 3000

# Start the Rails server
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
