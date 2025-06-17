FROM ruby:3.4.4

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install -j4

COPY . /app

EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
