module ReactQueryBuilder

	class QueryBuilderController < ApplicationController

		def index
			@queries = ReactQueryBuilder::QbSavedQuery.all
			@reports = ReactQueryBuilder::QueryBuilder.reports
		end

		def new
			ReactQueryBuilder::QueryBuilder.report_included?(params[:query_type]) ?
				config_report(run_query: false) :
				redirect_to(react_query_builder_rails_engine.query_builder_index_path)
		end

		def create
			respond_to do |format|
				format.html do
					if button_text_includes?(text: "Save Field Mappings")
						save_field_mappings
					elsif button_text_includes?(text: "Run Query")
						run_query
					else
						save_query
					end
				end

				format.json do
					config_report(options: get_params, render: false, include_data: true)
					render json: @query_report.data.map { |row| @query.display_row(row) }
				end
			end
		end

		def edit
			config_report(use_saved_params: true)
		end

		def update
			save_query
		end

		def show
			config_report(use_saved_params: true, render: false)
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

		def button_text_includes?(text:)
			params[:commit].present? && params[:commit].include?(text)
		end

		def query_form
			params[:react_query_builder_save_query]
		end

		def save_button?
			params[:commit] == "Save  "
		end

		def save_as_query_criteria?
			query_form.present? && @query_form.validate(query_form) && !save_button?
		end

		def save_query_criteria?
			update_page && save_button? && params[:id].present?
		end

		def update_page
			params[:action] == "update"
		end

		def save_field_mappings
			@mapping = QbFieldMapping.find_by(model: params[:query_type].classify)
			qfm = @mapping.update(labels: params[:field_mapping])
			flash[:success] = "Query Field Mappings successfully updated." if qfm
			redirect_to update_page ?
				            react_query_builder_rails_engine.edit_query_builder_path(id: params[:id]) :
				            react_query_builder_rails_engine.new_query_builder_path(query_type: params[:query_type])
		end

		def run_query
			config_report(run_query: params[:display_fields] ? true : false)
		end

		def save_query
			@path = form_path
			@query = ReactQueryBuilder::QbSavedQuery.new
			@query_form = ReactQueryBuilder::SaveQueryForm.new(@query)

			@params_for_save = set_params
			@params_for_save[:q] = @params_for_save[:q].nil? ? {} : @params_for_save[:q].to_json

			if save_as_query_criteria?
				save_as_query_to_db
			elsif save_query_criteria?
				save_query_to_db
			else
				render 'save_query'
			end
		end

		def save_as_query_to_db
			@query_form.save
			query_redirect
		end

		def save_query_to_db
			@query = ReactQueryBuilder::QbSavedQuery.find_by(id: params[:id])
			if @query.present?
				@query.update(q: @params_for_save[:q], display_fields: @params_for_save[:display_fields])
				return query_redirect
			end
			redirect_to react_query_builder_rails_engine.query_builder_index_path
		end

		def query_redirect
			@query.set_last_run_time(user: defined?(current_user) ? current_user : nil)
			flash[:success] = "Query was successfully saved"
			redirect_to react_query_builder_rails_engine.query_builder_index_path(query_type: @query.query_type)
		end

		def config_report(options: set_params,
		                  run_query: true,
		                  use_saved_params: false,
		                  render: true,
		                  include_data: false)
			@query_report = ReactQueryBuilder::QueryReport.new(options: options,
			                                       run_query: run_query,
			                                       use_saved_params: use_saved_params,
			                                       form_path: form_path,
			                                       params: params,
			                                       include_data: include_data)
			@query = @query_report.query

			@path = @query_report.path

			return redirect_to react_query_builder_rails_engine.query_builder_index_path if params[:id] && @query.nil?
			render 'query_form' if render
		end

		def form_path
			params[:id] ?
				{ url: react_query_builder_rails_engine.query_builder_path(id: params[:id]), html: { method: :patch } } :
				{ url: react_query_builder_rails_engine.query_builder_index_path, html: { method: :post }  }
		end

		def initial_hash
			Hash.new{|hash, key| hash[key] = Hash.new{|hash, key| hash[key] = Array.new}}
		end

		def set_params
			cols = initial_hash
			@cols = params[:display_fields]
			params[:display_fields].each { |c| cols[c] = "1" } unless params[:display_fields].nil?
			{
				display_fields: params[:display_fields].nil? ? {} : cols.to_json,
				q: params[:q],
				query_type: params[:query_type]
			}
		end

		def get_params
			{
				display_fields: params[:display_fields].empty? ? {} : params[:display_fields],
				q: params[:q].empty? ? {} : JSON.parse(params[:q]),
				query_type: params[:query_type]
			}
		end

	end

end