#spec_helper.rb
require 'rspec/autorun'
require 'rails'
Rails.backtrace_cleaner.remove_silencers!
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
	config.mock_with :rspec
	config.order = "random"
end