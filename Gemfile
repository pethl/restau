source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
#recomended by heroku
ruby '2.3.1'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Using Postgres database
gem 'pg', '0.17.1'
# Use SCSS for stylesheets

# Use Puma as the app server - action to try to remove the procfile error in heroku deploy log.
gem 'puma'


gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

#problems with rake 1/9/19 fix to pin rake version
gem 'rake', '< 11.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

gem 'bcrypt-ruby', '3.1.2'
# no longer needed according to heroku
#gem 'heroku'

gem 'bootstrap-sass', '~> 3.2.0'
gem 'bootstrap_form'

#datepicker
gem 'bootstrap-datepicker-rails'

# for contact us form, based on railscast 326
gem 'active_attr'

#recomended to make asset pipeline work
gem 'rails_12factor', group: :production

group :development do
  gem 'guard-minitest', '~> 2.3.2' # https://github.com/guard/guard-minitest
  # Colorize minitest output and show failing tests instantly.
  gem 'minitest-colorize', git: 'https://github.com/ysbaddaden/minitest-colorize'
  gem 'terminal-notifier-guard', '~> 1.6.4' # https://github.com/Springest/terminal-notifier-guard
  gem 'terminal-notifier', '~> 1.6.2' #https://github.com/alloy/terminal-notifier
end  

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'


# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'quiet_assets'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # for testing from the rspec book
  gem "rspec-rails", "~> 3.1.0"
  gem "factory_girl_rails", "~>4.4.1"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # for testing from the rspec book
  gem "faker", "~> 1.4.3"
#  gem "capybara", "~> 2.4.3"
  gem "database_cleaner", "~> 1.3.0"
  gem "launchy", "~> 2.4.2"
  gem "selenium-webdriver", "~>2.43.0"
end

gem 'newrelic_rpm'
gem 'prawn'
gem 'prawn-table'
gem 'groupdate'
gem "chartkick", "~> 3.2.0"

# recommended by github cant see why needed
#gem "activejob", ">= 4.2.11"
gem "rack", ">= 1.6.4" #as was unable to upgrade without causing other errors 
##gem "ffi", ">= 1.9.24"
##gem "sprockets", ">= 3.7.2"
##gem "loofah", ">= 2.2.3"
##gem "nokogiri", ">= 1.8.5"
#gem "activerecord", ">= 4.2.7.1"
#gem "activemodel", ">= 4.2.5.1"
#gem "actionview", ">= 4.2.11.1"
##gem "rails-html-sanitizer", ">= 1.0.4"
#gem "actionpack", ">= 4.2.5.2"
#gem "activesupport", ">= 4.2.2"
##gem "rubyzip", ">= 1.2.2"
