# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.4'

gem 'bootsnap', require: false
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.1.0'

gem 'pg', '~> 1.1'

gem 'rack-attack'
gem 'rack-cors'

gem 'base64'
gem 'bigdecimal'
gem 'drb'
gem 'mutex_m'
gem 'observer'

gem 'jb'
gem 'jwt'
gem 'kaminari'

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'annotate'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end
