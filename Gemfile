source 'https://rubygems.org'
ruby '2.2.10'

gem 'rails', '~> 4.0.0'
gem 'rake', '< 11.0'

gem 'nokogiri', '~> 1.8.0'
gem 'icalendar'
gem 'httparty', '~> 0.11.0'

gem 'dotenv-rails'

group :assets do
  gem 'uglifier', '~> 1.2.2'
end

gem 'jquery-rails'
gem 'formtastic-plus-bootstrap'
gem "bootstrap-sass", "~> 2.3"
gem 'dalli', '~> 1.1.4'

group :test, :development do
  gem 'sqlite3'
  gem 'test-unit'
  gem 'rspec-rails', '~> 2.12.0'
  gem 'factory_bot_rails', '~> 4.11.0'
  gem 'log_buddy', '~> 0.6.0'
  gem 'rubocop'
  gem 'rspec_junit_formatter'
end

group :development do
  gem 'powder', '~> 0.1.7'
  gem 'taps'
  gem 'growl', '~> 1.0.3'
end

group :test do
  gem 'turn', '~> 0.8.3', require: false
  gem 'timecop', '~> 0.3.5'
  gem 'fakeweb', '~> 1.3.0'
  gem 'rspec', '~> 2.12.0'
  gem 'spork', '~> 0.9.0'
  gem 'vcr', '~> 2.4.0'
end

group :production do
  gem 'pg', '~> 0.12.2'
  gem 'unicorn'
end
