require "rails/generators"

module ReactQueryBuilder
	module Generators
		class RouteGenerator < ::Rails::Generators::Base

			def create
				route 'mount ReactQueryBuilder::Rails::Engine, at: "/"'
			end

		end
	end
end