class QueryBuilderRecord < ApplicationRecord

	self.abstract_class = true

	def self.user_method
		"username"
	end

end