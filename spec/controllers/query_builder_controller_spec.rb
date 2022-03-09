require 'spec_helper'

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

		it 'should redirect to the QB Person Query if Saved Field Mappings is clicked' do
			post :create, params: { query_type: "qb_person", commit: "Save Field Mappings" }
			expect(response).to redirect_to('/query_builder/new?query_type=qb_person')
		end

		it 'should render the query form view if Run Query is clicked' do
			post :create, params: { query_type: "qb_person", commit: "Run Query" }
			expect(response.code).to render_template("query_form")
		end

		it 'should render Save Query form to save query for first time' do
			post :create, params: { query_type: "qb_person",
				                     commit: "Save  ",
			                       q: '{"g":{"0":{"m":"and","c":{"0":{"a":{"0":{"name":"last_name"}},"p":"cont","v":{"0":{"value":"' + Person.first.last_name + '"}}}}}}}' }
			expect(response).to render_template("save_query")
		end

		it 'should render Save Query form to save existing query' do
			post :create, params: { query_type: "qb_person",
			                       commit: "Save  ",
			                       id: "1" }
			expect(response).to render_template("save_query")
		end

		it 'should save the Query as a new Query if appropriate parameters are sent' do
			post :create, params: { query_type: "qb_person", react_query_builder_save_query: { title: "Sample Title", description: "Sample Description" } }
			expect(response).to redirect_to('/query_builder')
		end

		it 'should return the query results as JSON if that is the requested format' do
			post :create, { :format => 'json', :params => { query_type: "qb_person",
			                                               display_fields: '{"first_name":"1","middle_name":"1","last_name":"1"}',
			                                               q: '{"g":{"0":{"m":"and","c":{"0":{"a":{"0":{"name":"last_name"}},"p":"cont","v":{"0":{"value":"' + Person.last.last_name + '"}}}}}}}'} }

			output = response.stream.instance_values["buf"].first

			expect(output).to include(Person.last.last_name)
			expect(JSON.parse(output).first.class).to eq(Hash)
		end

	end

	describe "edit" do

		it 'should render the Query Form as Edit Person Query if we are accessing a saved query' do
			get :edit, { params: { id: ReactQueryBuilder::QbSavedQuery.first.id } }
			expect(response.body).to include('Edit Person Query')
			expect(response.body).to include('First Name')
			expect(response.body).to include('Middle Name')
			expect(response.body).to include('Last Name')
			expect(response).to render_template("query_form")
		end

		it 'should redirect to index if passed invalid ID' do
			get :edit, { params: { id: 100 } }
			expect(response).to redirect_to('/query_builder')
		end

	end

	describe "update" do

	end

	describe "show" do

		it 'should redirect to index if passed invalid ID' do
			get :show, { params: { id: 100 } }
			expect(response).to redirect_to('/query_builder')
		end

		it 'should render the show template, title, and description if ID is valid' do
			get :show, { params: { id: ReactQueryBuilder::QbSavedQuery.first.id } }
			expect(response.body).to include(ReactQueryBuilder::QbSavedQuery.first.title)
			expect(response.body).to include(ReactQueryBuilder::QbSavedQuery.first.description)
			expect(response).to render_template("show")
		end

	end

	describe "destroy" do

		it 'should redirect to index if passed invalid ID' do
			delete :destroy, { params: { id: 100 } }
			expect(response).to redirect_to('/query_builder')
		end

		it 'should redirect to the QB Person query page if delete is successful' do
			delete :destroy, { params: { id: ReactQueryBuilder::QbSavedQuery.first.id } }
			expect(response).to redirect_to('/query_builder?query_type=qb_person')
		end

		it 'should delete the specified query by ID' do
			expect(ReactQueryBuilder::QbSavedQuery.count).to eq(1)
			delete :destroy, { params: { id: ReactQueryBuilder::QbSavedQuery.first.id } }
			expect(ReactQueryBuilder::QbSavedQuery.count).to eq(0)
		end

	end

end