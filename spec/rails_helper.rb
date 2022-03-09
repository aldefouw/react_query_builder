#rails_helper.rb
ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

#We need to manually include our gems since they are NOT auto-loaded (no Gemfile in Dummy application)
require 'rails/all'

require 'pry'

require 'bootstrap'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'react-rails'
require 'simple_form'
require 'reform/rails'
require 'rails-controller-testing'
require 'database_cleaner'
require 'faker'
require 'scenic'
require 'scenic_sqlite_adapter'

require 'react_query_builder'

require File.expand_path('../dummy/config/environment.rb', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'