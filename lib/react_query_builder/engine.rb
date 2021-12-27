module ReactQueryBuilder
	module Rails
		class Engine < ::Rails::Engine
			Engine.config.assets.paths << root.join('node_modules')
		end
	end
end