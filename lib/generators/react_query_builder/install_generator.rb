require "rails/generators"
require "rails/generators/active_record"
require 'generators/react_query_builder/migrations_generator'
require 'generators/react_query_builder/models_generator'

module ReactQueryBuilder
	module Generators
		class InstallGenerator < Rails::Generators::Base

			source_root File.expand_path("/templates", __FILE__)

			def initialize(*)
				super
				@migrations = ReactQueryBuilder::Generators::MigrationsGenerator.new
				@models = ReactQueryBuilder::Generators::ModelsGenerator.new
			end

			def install
				@migrations.create
				@models.create
			end

		end
	end
end