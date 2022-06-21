module ReactQueryBuilder

	class QbPerson < QueryBuilder

		load_enums_for(models: [Person])

		def self.title
			'Person'
		end

		def boolean_override
			{:trained => ["Trained", "Untrained"]}
		end

		def self.type_overrides
			{
				:account_timeout => :numeric
			}
		end

		def account_timeout
			time_to_minutes(super)
		end

		private

		def time_to_minutes(t)
			return nil if t.nil?
			s = (((t.min * 60).to_f + t.sec.to_f) / 60).to_f
			m = '%.f' % s
			"#{m} minute#{"s" unless m == "1"}"
		end

	end

end