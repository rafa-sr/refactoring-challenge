source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"
gem "rails", "~> 7.0.2", ">= 7.0.2.3"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 6.0.0.rc1'
  gem  'simplecov', require: false
end

group :development, :test do
  gem 'faker'
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'byebug'
  gem 'rubocop-rails'
  gem 'rubocop-gemfile'
  gem 'rubocop-rspec'
  gem 'ruby-prof'
end
