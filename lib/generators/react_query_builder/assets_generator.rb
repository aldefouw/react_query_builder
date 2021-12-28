require "rails/generators"

module ReactQueryBuilder
	module Generators
		class AssetsGenerator < ::Rails::Generators::Base
			source_root File.expand_path("templates", __dir__)

			def create
				copy_file('app/assets/javascripts/react_query_builder.js', 'app/assets/javascripts/react_query_builder.js')
				copy_file('app/assets/stylesheets/react_query_builder.css', 'app/assets/stylesheets/react_query_builder.css')

				append_to_file 'app/assets/config/manifest.js' do
					"\n\n" +
					"//= link react_query_builder/manifest.js\n" +
					"//= link react_query_builder.js\n" +
					"//= link react_query_builder.css\n" +
					"//= link react_query_builder/react_query_builder.css\n"
				end

			end

		end
	end
end