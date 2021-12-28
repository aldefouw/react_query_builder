require "rails/generators"

module ReactQueryBuilder
	module Generators
		class ModelsGenerator < ::Rails::Generators::Base
			source_root File.expand_path("templates", __dir__)

			def models
				["query_builder_record.rb"]
			end

			def create
				if generating?
					models.each do |model|
						template "models/#{model}", "app/models/#{model}"
					end
				end
			end

			private

			def generating?
				behavior != :revoke
			end
		end
	end
end