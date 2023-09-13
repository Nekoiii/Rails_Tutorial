FROM ruby:3.2.2

RUN apt-get update -qq

ENV APP_HOME /app
WORKDIR $APP_HOME


COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock

RUN bundle install --jobs=2
# install nodejs(LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs
# install yarn
RUN npm install --global yarn
RUN apt-get update && apt-get -y install imagemagick

COPY . $APP_HOME
# ADD v.s COPY: https://www.cnblogs.com/zdz8207/p/linux-docker-add-copy.html

# CMD ["bundle", "exec", "rails", "s", "-p", "3000"]
CMD ["bundle", "exec", "rails", "s", "puma", "-b", "0.0.0.0", "-p", "3000", "-e", "development"]
