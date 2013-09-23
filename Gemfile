source 'https://rubygems.org'

ruby "2.0.0"

gem 'rails', '4.0.0'
gem 'pg'
gem 'unicorn'
gem 'cancan'

group :doc do
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry-debugger'
end

group :test do

end

group :production do
  gem 'newrelic_rpm'
  gem 'unicorn'
  gem 'rails_12factor'
end
