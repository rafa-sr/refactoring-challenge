# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.2', '>= 7.0.2.3'
gem 'resque', '~> 2.2'
gem 'redis', '~> 4.7.1'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :test do
  gem 'database_cleaner', '~> 2.0.1'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'rspec-rails', '~> 6.0.0.rc1'
  gem 'simplecov', require: false
end

group :development, :test do
  gem 'resque-web'
  gem 'benchmark-ips'
  gem 'byebug'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'faker'
  gem 'rubocop-gemfile'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end
