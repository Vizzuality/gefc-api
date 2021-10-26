source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Solves mimemagic Dependancy.
gem 'mimemagic', '0.3.5', git: 'https://github.com/mimemagicrb/mimemagic', ref: '01f92d8'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# .env files
gem 'dotenv-rails'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
# Devise is a flexible authentication solution for Rails based on Warden.. Read more: https://github.com/heartcombo/devise
gem 'devise'
# A ruby implementation of the RFC 7519 OAuth JSON Web Token (JWT) standard. Read more: https://github.com/jwt/ruby-jwt
gem 'jwt'
# A Ruby on Rails framework for creating elegant backends for website administration. Read more: https://github.com/activeadmin/activeadmin
gem 'activeadmin'
# access to features of the PostGIS geospatial database from ActiveRecord
gem 'activerecord-postgis-adapter'
# Exception tracking
gem 'appsignal'

# REST-like API framework for Ruby. Read more: https://github.com/ruby-grape/grape
gem 'grape'
# Is an API focused facade that sits on top of an object model. Read more: https://github.com/ruby-grape/grape-entity 
gem 'grape-entity'
#
gem 'grape-rails-cache'
#
gem 'dalli'
# Provides an autogenerated documentation for your Grape API. Read more: https://github.com/tim-vandecasteele/grape-swagger
gem 'grape-swagger'
# Swagger UI as Rails Engine for grape-swagger gem. Read more: https://github.com/ruby-grape/grape-swagger-rails
gem 'grape-swagger-rails'
# Provides support for Cross-Origin Resource Sharing (CORS) for Rack compatible web applications. Read more: https://github.com/cyu/rack-cors
gem 'rack-cors', :require => 'rack/cors'
# GeoJSON encoding and decoding
gem 'rgeo-geojson'
# Model translations
gem 'traco'
# A fast XML parser and Object marshaller as a Ruby gem. Read more: https://github.com/ohler55/ox
gem 'ox'
# AWS SDK for Ruby. Read more: https://github.com/aws/aws-sdk-ruby
gem "aws-sdk-s3", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # brings the RSpec testing framework to Ruby on Rails as a drop-in alternative to its default testing framework. Read more: https://github.com/rspec/rspec-rails
  gem 'rspec-rails', '~> 5.0.0'
  # factory_bot is a fixtures replacement with a straightforward definition syntax. Read more: https://github.com/thoughtbot/factory_bot
  gem "factory_bot_rails"
  # This gem is a port of Perl's Data::Faker library that generates fake data. Read more: https://github.com/faker-ruby/faker
  gem 'faker'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  #
  gem 'memory_profiler'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem "capistrano", "~> 3.15", require: false
  gem "capistrano-rails", "~> 1.6", require: false
  gem 'capistrano-rbenv', '~> 2.2'
  gem 'capistrano-bundler'
  gem 'capistrano3-puma'
  gem 'capistrano-yarn'
  gem 'rubocop', '~> 1.10.0', require: false
  gem 'rubocop-rails'
  gem 'rubocop-performance', require: false
  #
  gem 'bullet'
end

group :test do
  gem 'simplecov', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
