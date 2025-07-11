FROM ruby:3.2.0

# Install dependencies: SQLite, Node.js, Yarn
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libsqlite3-dev \
    nodejs \
    yarn

# Set working directory inside the container
WORKDIR /app

# Copy Gemfile and Gemfile.lock first to cache gem installation
COPY Gemfile Gemfile.lock /app/

# Install Ruby gems
RUN gem install bundler && bundle install

# Copy the rest of the Rails app
COPY . /app

# Create the SQLite database
RUN rails db:create

# Expose port 3000 for the Rails server
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]