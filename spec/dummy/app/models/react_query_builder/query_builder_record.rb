module ReactQueryBuilder

	class QueryBuilderRecord < ApplicationRecord

		self.abstract_class = true

		def self.user_method
			"username"
		end

		def self.results(search)
			search.result(distinct: true)
		end

	end

end