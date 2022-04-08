module ReactQueryBuilder

	class QueryReport < ApplicationController

		def initialize(options:,
                   run_query: true,
                   use_saved_params: false,
                   render: true,
                   params:,
                   form_path:,
                   include_data: false,
                   engine:)

			@query = params[:id] && use_saved_params ?
				         ReactQueryBuilder::QbSavedQuery.find_by(id: params[:id]) :
				         ReactQueryBuilder::QbSavedQuery.new(options)


			if @query.present?
				@query_params = params[:q] ? params[:q].to_json : @query.q
				@report = @query.current_query
				@search = @report.ransack(use_saved_params ? JSON.parse(@query.q) : options[:q])
				@search.build_grouping unless @search.groupings.any?

				@title = "#{params[:id] ? "Edit" : "New"} #{@report.title} Query"
				@path = form_path

				@run_query = run_query
				@data = @report.results(@search) if include_data
			else
				@query = nil
				@query_params = nil
				@report = nil
				@search = nil
				@title = nil
				@path = nil
				@run_query = nil
				@data = nil
			end
		end

		def test
			return @query, @query_params, @report, @search, @title, @path, @run_query, @data
		end

	end

end