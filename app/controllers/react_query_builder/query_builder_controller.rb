module ReactQueryBuilder

	class QueryBuilderController < ApplicationController

		def index
			@queries = ReactQueryBuilder::QbSavedQuery.all
			@reports = ReactQueryBuilder::QueryBuilder.reports
		end

		def new
			ReactQueryBuilder::QueryBuilder.report_included?(params[:query_type]) ?
				query_report(run_query: false) :
				redirect_to(react_query_builder_rails_engine.query_builder_index_path)
		end

		def create
			respond_to do |format|
				format.html do
					if params[:commit].present? && params[:commit].include?("Save Field Mappings")
						save_field_mappings
					elsif params[:commit].present? && params[:commit].include?("Run Query")
						query_report(run_query: params[:display_fields] ? true : false)
					else
						save_query
					end
				end

				format.json do
					query_report(render: false, include_data: true)
					render json: @query_report.data.map { |row| @query.display_row(row) }
				end
			end
		end

		def edit
			query_report(use_saved_params: true)
		end

		def update
			save_query
		end

		def show
			query_report(use_saved_params: true, render: false)
		end

		def destroy
			@query = ReactQueryBuilder::QbSavedQuery.find_by(id: params[:id])
			if @query.nil?
				flash[:warning] = "This query does not exist."
				redirect_to react_query_builder_rails_engine.query_builder_index_path
			else
				@query.delete
				flash[:success] = "#{@query.title} query successfully deleted"
				redirect_to react_query_builder_rails_engine.query_builder_index_path(query_type: @query.query_type)
			end
		end

		private

		def save_field_mappings
			@mapping = ReactQueryBuilder::QbFieldMapping.find_by(model: params[:query_type].classify)
			qfm = @mapping.update(labels: params[:field_mapping])
			flash[:success] = "Query Field Mappings successfully updated." if qfm
			redirect_to params[:action] == "update" ?
				            react_query_builder_rails_engine.edit_query_builder_path(id: params[:id]) :
				            react_query_builder_rails_engine.new_query_builder_path(query_type: params[:query_type])
		end

		def save_query
			@save_report = ReactQueryBuilder::SaveReport.new(params: params,
			                              form_path: form_path)
			saved_query = @save_report.attempt_save

			if saved_query.present?
				@save_report.query.set_last_run_time(user: defined?(current_user) ? current_user : nil)
				flash[:success] = "Query was successfully saved."
			elsif saved_query === false
				return render 'save_query'
			end
			redirect_to react_query_builder_rails_engine.query_builder_index_path(@save_report.query.present? ? { query_type: @save_report.query.query_type} : {})
		end

		def query_report(run_query: true,
		                  use_saved_params: false,
		                  render: true,
		                  include_data: false)
			@query_report = ReactQueryBuilder::QueryReport.new(run_query: run_query,
                                      use_saved_params: use_saved_params,
                                      form_path: form_path,
                                      params: params,
                                      include_data: include_data)

			@query = @query_report.query
			return redirect_to react_query_builder_rails_engine.query_builder_index_path if params[:id] && @query_report.query.nil?
			render 'query_form' if render
		end

		def form_path
			params[:id] ?
				{ url: react_query_builder_rails_engine.query_builder_path(id: params[:id]), html: { method: :patch } } :
				{ url: react_query_builder_rails_engine.query_builder_index_path, html: { method: :post }  }
		end

	end

end