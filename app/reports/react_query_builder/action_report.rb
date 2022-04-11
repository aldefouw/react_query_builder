module ReactQueryBuilder

	class ActionReport

		def initialize(run_query: true,
		               use_saved_params: false,
		               params:,
		               engine:,
		               include_data: false)
			@params = params
			@engine = engine
			@options = include_data ? get_params : set_params
			@use_saved_params = use_saved_params
			@form_path = form_path
			@run_query = run_query
			@include_data = include_data
		end

		def choose_action
			if @params[:commit].present? && @params[:commit].include?("Save Field Mappings")
				save_field_mappings
			elsif @params[:commit].present? && @params[:commit].include?("Run Query")
				fetch_report
			else
				save_query
			end
		end

		def save_field_mappings
			mapping = ReactQueryBuilder::QbFieldMapping.find_by(model: @params[:query_type].classify)
			mapping.update(labels: @params[:field_mapping])
			@params[:action] == "update" ?
				@engine.edit_query_builder_path(id: params[:id]) :
        @engine.new_query_builder_path(query_type: params[:query_type])
		end

		def fetch_report
			query_report = ReactQueryBuilder::QueryReport.new(run_query: @run_query,
			                                                  use_saved_params: @use_saved_params,
			                                                  form_path: @form_path,
			                                                  params: @params,
			                                                  include_data: @include_data)
			query_report.query
			@engine.query_builder_index_path if @params[:id] && query_report.query.nil?
		end

		def save_query
			save_report = ReactQueryBuilder::SaveReport.new(params: @params, form_path: @form_path)
			save_report.attempt_save
			@engine.query_builder_index_path(save_report.query.present? ? { query_type: save_report.query.query_type} : {})
		end

		private

		def set_params
			cols = Hash.new{|hash, key| hash[key] = Hash.new{|hash, key| hash[key] = Array.new}}
			@params[:display_fields].each { |c| cols[c] = "1" } unless @params[:display_fields].nil?
			{
				display_fields: @params[:display_fields].nil? ? {} : cols.to_json,
				q: @params[:q],
				query_type: @params[:query_type]
			}
		end

		def get_params
			{
				display_fields: @params[:display_fields].empty? ? {} : @params[:display_fields],
				q: @params[:q].empty? ? {} : JSON.parse(@params[:q]),
				query_type: @params[:query_type]
			}
		end

		def form_path
			@params[:id] ?
				{ url: @engine.query_builder_path(id: @params[:id]), html: { method: :patch } } :
				{ url: @engine.query_builder_index_path, html: { method: :post }  }
		end

	end

end