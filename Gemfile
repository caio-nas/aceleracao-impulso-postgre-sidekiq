source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'after_commit_everywhere', '~> 0.1', '>= 0.1.5'
gem 'awesome_print', '1.8.0'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'redis', '4.2.5'
gem 'rest-client', '2.1.0'
gem 'scenic', '1.5.4'
gem 'sidekiq', '6.1.3'
gem 'store_model', '0.8.0'

group :development do
  gem 'dotenv-rails', '2.7.6'
  gem 'foreman', '0.87.2'
  gem 'listen', '~> 3.2'
  gem 'spring', '2.1.1'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :test do
  gem 'factory_bot_rails', '6.1.0'
  gem 'ffaker'
  gem 'pry-rails', '0.3.9'
  gem 'pry-byebug', '3.9.0'
  gem 'execution_time', '0.1.2'
end

group :test do
  gem 'database_cleaner', '2.0.1'
  gem 'faker', '2.15.1'
  gem 'rails-controller-testing', '1.0.5'
  gem 'rspec-benchmark', '0.6.0'
  gem 'rspec-collection_matchers', '1.2.0'
  gem 'rspec-rails', '4.0.2'
  gem 'shoulda-callback-matchers', '1.1.4'
  gem 'shoulda-matchers', '4.5.1'
  gem 'simplecov', '0.21.2', require: false
end
