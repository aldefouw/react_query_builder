# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'react_query_builder/version'

Gem::Specification.new do |spec|
	spec.name        =    'react_query_builder'
	spec.version     =    ReactQueryBuilder::VERSION
	spec.summary     =    "React-based interface for querying database views."
	spec.description =    "A library that allows you to add a plug-and-play Query Engine to your Rails application."
	spec.authors     =    ["Adam De Fouw"]
	spec.email       =    'adefouw@gmail.com'
	spec.files       =    ["lib/react_query_builder.rb"]
	spec.require_paths =  ["lib"]
	spec.license     =    'MIT'

	spec.metadata    = {
		"homepage_uri"      => "https://github.com/aldefouw/react_query_builder",
		"documentation_uri" => "https://rubydoc.info/github/aldefouw/react_query_builder",
		"source_code_uri"   => "https://github.com/aldefouw/react_query_builder",
		"bug_tracker_uri"   => "https://github.com/aldefouw/react_query_builder/issues",
		"wiki_uri"          => "https://github.com/aldefouw/react_query_builder/wiki"
	}

	spec.add_development_dependency 'scenic', "~> 2.0"

	spec.add_runtime_dependency 'bootstrap', '~> 4.1'
	spec.add_runtime_dependency 'sass-rails', '~> 6.0'

	spec.add_runtime_dependency 'jquery-ui-rails', "~> 6.0"
	spec.add_runtime_dependency "jquery-rails", "~> 4.4"
	spec.add_runtime_dependency 'react-rails', "~> 2.4"

	spec.add_runtime_dependency 'ransack', "~> 2.4"

	spec.add_runtime_dependency "simple_form", "~> 5.1"
	spec.add_runtime_dependency "reform", "~> 2.2"
	spec.add_runtime_dependency "reform-rails", "~> 0.1"

end