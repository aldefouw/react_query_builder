module ReactQueryBuilder

	class QueryReport

		def initialize(run_query:,
                   use_saved_params:,
                   params:,
                   form_path:,
                   include_data:)
			@params = params
			@options = ReportParams.new(include_data: include_data, params: params).options
			@use_saved_params = use_saved_params
			@form_path = form_path
			@run_query = run_query
			@include_data = include_data
			@query = query
		end

		def query
			@params[:id] && @use_saved_params ?
				QbSavedQuery.find_by(id: @params[:id]) :
				QbSavedQuery.new(@options)
		end

		def title
			if @query.present? && @query.current_query.present?
				"#{@params[:id] ? "Edit" : "New"} #{report.title} Query"
			end
		end

		def search
			if @query.present?
				s = report.ransack(@use_saved_params ? JSON.parse(@query.q) : @options[:q])
				s.build_grouping unless s.groupings.any?
				s
			end
		end

		def path
			@form_path
		end

		def labels
			report.labels if @query.present?
		end

		def report
			@query.current_query if @query.present?
		end

		def columns
			@params[:display_fields]
		end

		def run_query
			@run_query if @query.present?
		end

		def query_params
			if @query.present?
				@params[:q] ? @params[:q].to_json : @query.q
			end
		end

		def data
			report.results(search) if @include_data
		end

	end

end