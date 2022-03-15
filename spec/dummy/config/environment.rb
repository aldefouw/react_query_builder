# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ReactQueryBuilder::QueryBuilderController.class_eval do

	def current_user
		Person.first
	end

end