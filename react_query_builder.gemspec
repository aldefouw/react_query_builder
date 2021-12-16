# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'react_query_builder/version'

Gem::Specification.new do |spec|
	spec.name        = 'react_query_builder'
	spec.version     = ReactQueryBuilder::VERSION
	spec.summary     = "React-based interface for querying database views."
	spec.description = "A library that allows you to add a Query Engine to your Rails application."
	spec.authors     = ["Adam De Fouw"]
	spec.email       = 'aldefouw@medicine.wisc.edu'
	spec.files       = ["lib/react_query_builder.rb"]
	spec.require_paths = ["lib"]
	spec.license     = 'MIT'
	spec.add_development_dependency 'scenic', "~> 2.0"
	spec.add_development_dependency 'ransack', "~> 2.4"
	spec.add_development_dependency 'react-rails', "~> 2.4"

	spec.add_development_dependency 'jquery-rails'

	spec.add_runtime_dependency 'bootstrap', '~> 4.6'
	spec.add_runtime_dependency 'sass-rails'

	spec.add_runtime_dependency 'react-rails', "~> 2.4"
	spec.add_runtime_dependency 'ransack', "~> 2.4"
	spec.add_runtime_dependency "jquery-rails"

end