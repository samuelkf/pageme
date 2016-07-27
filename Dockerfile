FROM ruby:2.3.0
MAINTAINER Samuel Keating-Fry <samhkf@gmail.com>

# Install gems
ENV APP_HOME /app
ENV HOME /root
RUN mkdir $APP_HOME
COPY Gemfile* $APP_HOME/
WORKDIR $APP_HOME

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
	BUNDLE_JOBS=2 \
	BUNDLE_PATH=/bundle

RUN bundle install

# Upload source
COPY . $APP_HOME

# Start server
CMD bundle exec unicorn -c config/unicorn.rb