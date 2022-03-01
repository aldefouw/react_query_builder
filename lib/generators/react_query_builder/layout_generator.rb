require "rails/generators"

module ReactQueryBuilder
	module Generators
		class LayoutGenerator < ::Rails::Generators::Base
			source_root File.expand_path("templates", __dir__)

			def create
				inject_into_file 'app/views/layouts/application.html.erb', before: "</head>\n" do <<-'RUBY'

		<!-- START: React Query Builder -->
		<% if request.env['PATH_INFO'].include?(react_query_builder_rails_engine.query_builder_index_path) %>
		  <%= stylesheet_link_tag    'react_query_builder/react_query_builder', media: 'all', 'data-turbolinks-track': 'reload' %>
		  <%= stylesheet_link_tag    'react_query_builder', media: 'all', 'data-turbolinks-track': 'reload' %>
		
		  <%= javascript_include_tag 'react_query_builder', 'data-turbolinks-track': 'reload' %>
		  <%= javascript_include_tag 'react_query_builder/react_query_builder', 'data-turbolinks-track': 'reload' %>
		  <script type="text/javascript">
			  //This is used to add the infinite number of Add Query Criteria / Nested Groupings
			  $(function() {
				  <%= yield :document_ready %>
			  });
		  </script>
		<% end %>
		<!-- END: React Query Builder -->

				RUBY
				end
			end

		end
	end
end