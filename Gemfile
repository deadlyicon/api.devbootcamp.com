source 'https://rubygems.org'

ruby "2.0.0"

gem 'rails', '4.0.0'
gem 'pg'
gem 'unicorn'
gem 'cancan'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'method_object'
gem 'cancan'

group :doc do
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry-debugger'
  gem 'debugger'
end

group :test do
  gem 'shoulda', github: 'thoughtbot/shoulda'
  gem 'factory_girl'
  gem 'activerecord-fixture_builder'
end

group :production do
  gem 'newrelic_rpm'
  gem 'unicorn'
  gem 'rails_12factor'
end
