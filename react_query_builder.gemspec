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

	spec.add_development_dependency 'scenic'
	spec.add_development_dependency 'rspec-rails'
	spec.add_development_dependency 'pry-rails'
	spec.add_development_dependency 'pry'
	spec.add_development_dependency 'bootsnap'
	spec.add_development_dependency 'capybara'
	spec.add_development_dependency 'rails-controller-testing'
	spec.add_development_dependency 'database_cleaner'
	spec.add_development_dependency 'bundler'

	spec.add_development_dependency 'puma'
	spec.add_development_dependency 'selenium-webdriver'

	spec.add_development_dependency 'sqlite3'

	spec.add_dependency 'bootstrap', '~> 4.1'
	spec.add_dependency 'sass-rails', '~> 6.0'

	spec.add_dependency 'jquery-ui-rails', "~> 6.0"
	spec.add_dependency "jquery-rails", "~> 4.4"
	spec.add_dependency 'react-rails', "~> 2.4"

	spec.add_dependency 'ransack', "~> 2.4"

	spec.add_dependency "simple_form", "~> 5.1"
	spec.add_dependency "reform", "~> 2.2"
	spec.add_dependency "reform-rails", "~> 0.1"

	spec.add_dependency 'rails'


	# Specify which files should be added to the gem when it is released.
	# The `git ls-files -z` loads the files in the RubyGem that have been added into git.
	spec.files = Dir.chdir(File.expand_path(__dir__)) do
		`git ls-files -z`.split("\x0").reject do |f|
			(f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
		end
	end
	spec.bindir = "exe"
	spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
	spec.require_paths = ["lib"]




end