require 'rails_helper'

RSpec.describe ReactQueryBuilder::QueryBuilderController, type: :controller do

	#Needed to ACTUALLY render views
	render_views

	#Needs to define the routes we're using
	routes { ReactQueryBuilder::Rails::Engine.routes }

	describe "index" do

		it "returns instance variable with all reports available" do
			get :index
			expect(assigns(:reports)).to eq([{:title=>"Person", :model=>"QbPerson"}])
		end

		it "returns instance variable with Active Record Relation array of saved queries available" do
			get :index
			expect(assigns(:queries).class.name).to eq("ActiveRecord::Relation")
			expect(assigns(:queries).first.class.name).to eq("ReactQueryBuilder::QbSavedQuery")
		end

		it "renders the index template" do
			get :index
			expect(response).to render_template("index")
		end

	end

	describe "new" do

		it "redirects if NO query_type is specified in the parameter string" do
			get :new
			expect(response).to redirect_to('/query_builder')
		end

		it "redirects if INVALID query_type is specified in the parameter string" do
			get :new, params: { query_type: "invalid_view" }
			expect(response).to redirect_to('/query_builder')
		end

		it "returns 200 status code if VALID query_type specified" do
			get :new, params: { query_type: "qb_person" }
			expect(response.status).to eq(200)
		end

		it 'renders the query_form view if VALID query_type specified' do
			get :new, params: { query_type: "qb_person" }
			expect(response).to render_template("query_form")
		end

	end

	describe "create" do
		
	end

	describe "edit" do

	end

	describe "update" do

	end

	describe "show" do

	end

	describe "destroy" do

	end

end