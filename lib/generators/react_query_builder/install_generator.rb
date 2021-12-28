require 'rails/generators'
require "rails/generators/active_record"

require 'generators/react_query_builder/migrations_generator'
require 'generators/react_query_builder/models_generator'
require 'generators/react_query_builder/layout_generator'
require 'generators/react_query_builder/route_generator'
require 'generators/react_query_builder/assets_generator'

module ReactQueryBuilder
	module Generators
		class InstallGenerator < ::Rails::Generators::Base

			source_root File.expand_path("/templates", __FILE__)

			def initialize(*)
				super
				@migrations = ReactQueryBuilder::Generators::MigrationsGenerator.new
				@models = ReactQueryBuilder::Generators::ModelsGenerator.new
				@layout = ReactQueryBuilder::Generators::LayoutGenerator.new
				@route = ReactQueryBuilder::Generators::RouteGenerator.new
				@assets = ReactQueryBuilder::Generators::AssetsGenerator.new
			end

			def install
				@migrations.create
				@models.create
				@layout.create
				@route.create
				@assets.create
			end

		end
	end
end