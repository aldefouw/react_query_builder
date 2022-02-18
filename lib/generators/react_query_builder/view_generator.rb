require "rails/generators"

module ReactQueryBuilder
	module Generators
		class ViewGenerator < ::Rails::Generators::Base

			source_root File.expand_path("templates", __dir__)

			def create
				model_name = args[0]

				generate "scenic:view qb_#{model_name}"

				text = "module ReactQueryBuilder
	class Qb#{model_name.classify} < ::QueryBuilder

	load_enums_for(models: [#{model_name.classify}])

	def self.model
		#{model_name.classify}
	end

	def self.title
		'#{model_name.classify}'
	end

end"

				create_file "app/models/react_query_builder/qb_#{args[0]}.rb" do text end

			end

		end
	end
end