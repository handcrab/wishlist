source 'https://rubygems.org'
# source 'http://production.s3.rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

group :production do
  gem 'pg'
  # Use Unicorn as the app server
  gem 'unicorn'
  # gem 'rails_12factor', group: :production
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'haml-rails'

gem 'rails-i18n'
# gem 'russian'

gem 'bootstrap-sass'
gem 'paperclip'
gem 'redcarpet'
# gem 'github-markdown', '~> 0.6.8'
# gem 'github-markup'

gem 'devise'
gem 'devise-bootstrap-views'

# gem 'omniauth'
gem 'omniauth-vkontakte' # , '~> 1.3.3'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  gem 'spring'

  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-its'
  gem 'shoulda-matchers'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'factory_girl_rails'

  gem 'guard-rspec' # guard :rspec, cmd:"spring rspec"
  gem 'guard-cucumber' # guard init cucumber

  gem 'spring-commands-rspec'
  gem 'spring-commands-cucumber'
  # bundle exec spring binstub #=> generate bin/rspec
  # spring stop
  # time spring rspec

  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  gem 'fuubar'
  gem 'fuubar-cucumber'
  gem 'bullet'
end

gem 'simplecov', require: false, group: :test
# gem "codeclimate-test-reporter", group: :test, require: nil
gem 'coveralls', require: false, group: :test
