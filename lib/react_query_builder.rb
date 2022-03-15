require "react_query_builder/version"
require 'ransack'

module ReactQueryBuilder

end

# :nocov:
case ::Rails.version.to_s
when /^7/
	require 'react_query_builder/engine'
when /^6/
	require 'react_query_builder/engine'
when /^5/
	require 'react_query_builder/engine'
else
	fail 'Unsupported rails version'
end
# :nocov: