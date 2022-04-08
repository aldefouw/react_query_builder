module ReactQueryBuilder

	class QueryReport < ApplicationController

		def initialize(options:,
                   run_query: true,
                   use_saved_params: false,
                   params:,
                   form_path:,
                   include_data: false)
			@params = params
			@options = options
			@use_saved_params = use_saved_params
			@form_path = form_path
			@run_query = run_query
			@include_data = include_data
			@query = query
		end

		def data
			report.results(search) if @include_data
		end

		def run_query
			@run_query if @query.present?
		end

		def path
			@form_path
		end

		def title
			if @query.present? && @query.current_query.present?
				"#{@params[:id] ? "Edit" : "New"} #{@query.current_query.title} Query"
			end
		end

		def search
			if @query.present?
				s = report.ransack(@use_saved_params ? JSON.parse(@query.q) : @options[:q])
				s.build_grouping unless s.groupings.any?
				s
			end
		end

		def report
			@query.current_query if @query.present?
		end

		def query_params
			if @query.present?
				@params[:q] ? @params[:q].to_json : @query.q
			end
		end

		def query
			@params[:id] && @use_saved_params ?
				ReactQueryBuilder::QbSavedQuery.find_by(id: @params[:id]) :
				ReactQueryBuilder::QbSavedQuery.new(@options)
		end

	end

end