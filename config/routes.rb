ReactQueryBuilder::Rails::Engine.routes.draw do
	scope :module => "react_query_builder" do
		resources :query_builder
	end
end