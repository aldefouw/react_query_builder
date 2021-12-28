require "rails/generators"

module ReactQueryBuilder
	module Generators
		class ViewGenerator < ::Rails::Generators::Base

			def create
				generate "scenic:view qb_#{args[0]}"
				generate "model qb_#{args[0]}"
			end

		end
	end
end