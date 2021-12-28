require 'rails/generators'
require "rails/generators/active_record"

module ReactQueryBuilder
	module Generators

		class MigrationsGenerator < ::Rails::Generators::Base

			include ::Rails::Generators::Migration

			source_root File.expand_path("templates", __dir__)

			def models
				['create_qb_field_mappings.rb', 'create_qb_saved_queries.rb']
			end

			def create
				models.each do |model|
					migration_template(
						"db/migrate/#{model}",
						"db/migrate/#{model}",
						)
				end
			end

			def self.next_migration_number(dir)
				::ActiveRecord::Generators::Base.next_migration_number(dir)
			end

		end
	end
end