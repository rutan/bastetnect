# bastetnect

## Development
### Setup: API
```
$ cp .env-sample .env
$ docker compose -f docker-compose.dev.yml build
$ docker compose -f docker-compose.dev.yml run --rm app bundle install
$ docker compose -f docker-compose.dev.yml run --rm app bundle exec rake db:create db:migrate db:seed
$ docker compose -f docker-compose.dev.yml up
```
