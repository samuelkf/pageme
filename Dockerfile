FROM ruby:2.3.0
MAINTAINER Samuel Keating-Fry <samhkf@gmail.com>

# Install gems
ENV APP_HOME /app
ENV HOME /root
RUN mkdir $APP_HOME
COPY Gemfile* $APP_HOME/
WORKDIR $APP_HOME

RUN bundle install

# Upload source
COPY . $APP_HOME

# Start server
CMD bundle exec unicorn -c config/unicorn.rb