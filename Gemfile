source 'https://rubygems.org'
ruby '2.1.3'

gem 'rails', '~> 3.2.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'haml', '~> 3.1.4'
gem 'haml-rails', '~> 0.3.4'
gem "formtastic", "~> 2.2"
gem 'nokogiri', '~> 1.5.0'
gem 'icalendar'
gem 'httparty', '~> 0.11.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '~> 1.2.2'
end

gem 'jquery-rails'
gem 'formtastic-plus-bootstrap'
gem "bootstrap-sass", "~> 2.3"
gem 'dalli', '~> 1.1.4'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test, :development do
  gem 'sqlite3'

  gem 'rspec-rails', '~> 2.8.0'
  gem 'factory_girl_rails', '~> 1.5.0'
  gem 'log_buddy', '~> 0.6.0'
end

group :development do
  gem 'powder', '~> 0.1.7'
  gem 'guard', '~> 0.9.4'
  gem 'guard-bundler', '~> 0.1.3'
  gem 'guard-spork', '~> 0.4.1'
  gem 'guard-rspec', '~> 0.5.10'
  gem 'guard-pow', '~> 0.2.1'
  gem 'heroku'
  gem 'taps'
  gem 'growl', '~> 1.0.3'
end

group :test do
  # Pretty printed test output
  gem 'turn', '~> 0.8.3', require: false
  gem 'timecop', '~> 0.3.5'
  gem 'fakeweb', '~> 1.3.0'
  gem 'rspec', '~> 2.8.0'
  gem 'spork', '~> 0.9.0'
  gem 'vcr', '~> 2.4.0'
end

group :production do
  gem 'pg', '~> 0.12.2'
  gem 'unicorn'
end
