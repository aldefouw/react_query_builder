require 'rails/generators'
require "rails/generators/active_record"

module ReactQueryBuilder
	module Generators

		class JqueryGenerator < ::Rails::Generators::Base

			def create
				text = "//= require jquery
//= require jquery_ujs\n"

				if File.exists?('app/assets/javascripts/application.js')
					prepend_to_file 'app/assets/javascripts/application.js', text
				else
					create_file 'app/assets/javascripts/application.js', text

					inject_into_file 'app/views/layouts/application.html.erb', before: '<!-- START: React Query Builder -->' do <<-'RUBY'
						<%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
RUBY
					end

				end

			end

		end
	end
end