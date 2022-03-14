module ReactQueryBuilder

	class QbPerson < QueryBuilder

		load_enums_for(models: [Person])

		def self.model
			Person
		end

		def self.title
			'Person'
		end

		def boolean_override
			{:trained => ["Trained", "Untrained"]}
		end

	end

end