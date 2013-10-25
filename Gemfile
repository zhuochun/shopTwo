source 'https://rubygems.org'

# Ruby version
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use postgresql as the database for Active Record
gem 'pg'

# Use devise to provide authentication
gem 'devise'

# Use cancan to provide authorization
gem "cancan"

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Bootstrap with SCSS favors
gem 'anjlab-bootstrap-rails', :require => 'bootstrap-rails', :github => 'anjlab/bootstrap-rails'

# Use paginate
gem 'will_paginate', '~> 3.0'

# Use simple_form for forms
gem 'simple_form'

# Use carrierwave to handle file uploads
gem 'carrierwave'

# Mass Import Data in ActiveRecord
gem "activerecord-import"

# Handle slow processes
gem 'delayed_job_active_record'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', :require => false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use Heroku Gems
group :production do
  gem 'rails_12factor'
end

# Development only
group :development, :test do
  # Better errors messages for debug
  gem "better_errors"
  # Load local environments
  gem 'dotenv-rails'
end

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development
