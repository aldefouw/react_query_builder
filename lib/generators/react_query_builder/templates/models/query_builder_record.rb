class QueryBuilderRecord < ApplicationRecord

	self.abstract_class = true

	def self.user_method
		"username"
	end

	def self.result_data(search)
		search.result(distinct: true)
	end

end