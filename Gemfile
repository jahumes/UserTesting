source 'https://rubygems.org'
gem 'rails', '3.2.8'
gem 'sqlite3'
gem "devise", ">= 2.1.2"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem 'jquery-rails'
gem "thin", ">= 1.4.1"
gem 'navigasmic'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :production do
  gem 'pg', '0.12.2'
  gem 'sprockets', '~> 2.0'
end

group :test do
  gem 'capybara', '>= 1.1.2'
  gem 'rb-inotify', '0.8.8'
  gem 'libnotify', '0.5.9'
  gem 'guard-spork', '0.3.2'
  gem 'spork', '0.9.0'
  gem 'factory_girl_rails', '>= 4.0.0'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '>= 2.11.0'
  gem 'guard-rspec', '0.5.5'
  gem 'annotate', '2.5.0', group: :development
end

gem "email_spec", ">= 1.2.1", :group => :test
gem "cucumber-rails", ">= 1.3.0", :group => :test, :require => false
gem "database_cleaner", ">= 0.8.0", :group => :test
gem "launchy", ">= 2.1.2", :group => :test

gem "therubyracer", ">= 0.10.2", :group => :assets, :platform => :ruby